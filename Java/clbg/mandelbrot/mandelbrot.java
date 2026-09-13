import java.io.BufferedOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicInteger;

public class mandelbrot {
    private static void renderRow(
            double[] real, double imaginary, byte[] image,
            int offset, int rowBytes, int n) {

        for (int bx = 0; bx < rowBytes; bx++) {
            int bits = 0;
            int base = bx << 3;

            for (int pair = 0; pair < 8; pair += 2) {
                double cr0 = real[base + pair];
                double cr1 = real[base + pair + 1];

                double zr0 = 0.0, zi0 = 0.0;
                double zr1 = 0.0, zi1 = 0.0;
                double rr0 = 0.0, ii0 = 0.0;
                double rr1 = 0.0, ii1 = 0.0;
                int escaped = 0;

                for (int iteration = 0; iteration < 50; iteration++) {
                    zi0 = 2.0 * zr0 * zi0 + imaginary;
                    zr0 = rr0 - ii0 + cr0;
                    zi1 = 2.0 * zr1 * zi1 + imaginary;
                    zr1 = rr1 - ii1 + cr1;

                    rr0 = zr0 * zr0;
                    ii0 = zi0 * zi0;
                    rr1 = zr1 * zr1;
                    ii1 = zi1 * zi1;

                    if (rr0 + ii0 > 4.0) {
                        escaped |= 2;
                    }
                    if (rr1 + ii1 > 4.0) {
                        escaped |= 1;
                    }
                    if (escaped == 3) {
                        break;
                    }
                }

                bits = (bits << 2) | (escaped ^ 3);
            }

            image[offset + bx] = (byte) bits;
        }

        int remaining = n & 7;
        if (remaining != 0) {
            image[offset + rowBytes - 1] &= (byte) (0xFF << (8 - remaining));
        }
    }

    public static void main(String[] args) throws Exception {
        final int n = Integer.parseInt(args[0]);
        final int rowBytes = (n >>> 3) + ((n & 7) == 0 ? 0 : 1);
        final byte[] image = new byte[Math.multiplyExact(n, rowBytes)];
        final double[] real = new double[Math.multiplyExact(rowBytes, 8)];

        for (int x = 0; x < n; x++) {
            real[x] = 2.0 * x / n - 1.5;
        }

        final AtomicInteger nextRow = new AtomicInteger();
        final Runnable render = () -> {
            int first;
            while ((first = nextRow.getAndAdd(4)) < n) {
                int end = Math.min(first + 4, n);
                for (int y = first; y < end; y++) {
                    double imaginary = 2.0 * y / n - 1.0;
                    renderRow(real, imaginary, image, y * rowBytes, rowBytes, n);
                }
            }
        };

        int workerCount = Math.min(n, Runtime.getRuntime().availableProcessors());
        Thread[] workers = new Thread[workerCount - 1];

        for (int i = 0; i < workers.length; i++) {
            workers[i] = new Thread(render);
            workers[i].start();
        }

        render.run();

        for (Thread worker : workers) {
            worker.join();
        }

        BufferedOutputStream out = new BufferedOutputStream(System.out, 65536);
        out.write(("P4\n" + n + " " + n + "\n").getBytes(StandardCharsets.US_ASCII));
        out.write(image);
        out.flush();
    }
}