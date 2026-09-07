import java.io.BufferedOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicInteger;

class mandelbrot {
    private static int size;
    private static int bytesPerRow;
    private static byte[] image;
    private static double[] realCoordinates;
    private static final AtomicInteger nextRow = new AtomicInteger();

    private static boolean isBounded(double cr, double ci) {
        double ci2 = ci * ci;

        // Main cardioid.
        double x = cr - 0.25;
        double q = x * x + ci2;
        if (q * (q + x) <= 0.25 * ci2) {
            return true;
        }

        // Period-2 bulb.
        double bulbX = cr + 1.0;
        if (bulbX * bulbX + ci2 <= 0.0625) {
            return true;
        }

        double zr = 0.0;
        double zi = 0.0;
        double zr2 = 0.0;
        double zi2 = 0.0;

        for (int i = 0; i < 50; i++) {
            zi = 2.0 * zr * zi + ci;
            zr = zr2 - zi2 + cr;
            zr2 = zr * zr;
            zi2 = zi * zi;

            if (zr2 + zi2 > 4.0) {
                return false;
            }
        }
        return true;
    }

    private static void computeRows() {
        int y;
        while ((y = nextRow.getAndIncrement()) < size) {
            double ci = (2.0 * y / size) - 1.0;
            int rowOffset = y * bytesPerRow;
            int x = 0;

            for (int columnByte = 0; columnByte < bytesPerRow; columnByte++) {
                int bits = 0;
                int count = Math.min(8, size - x);

                for (int bit = 0; bit < count; bit++, x++) {
                    bits <<= 1;
                    if (isBounded(realCoordinates[x], ci)) {
                        bits |= 1;
                    }
                }

                bits <<= 8 - count;
                image[rowOffset + columnByte] = (byte) bits;
            }
        }
    }

    public static void main(String[] args) throws Exception {
        size = Integer.parseInt(args[0]);
        bytesPerRow = (size + 7) >>> 3;
        image = new byte[size * bytesPerRow];
        realCoordinates = new double[size];

        for (int x = 0; x < size; x++) {
            realCoordinates[x] = (2.0 * x / size) - 1.5;
        }

        int processors = Runtime.getRuntime().availableProcessors();
        int threadCount = Math.min(processors, Math.max(1, size / 16));
        threadCount = Math.min(threadCount, 64);

        Thread[] workers = new Thread[threadCount - 1];
        for (int i = 0; i < workers.length; i++) {
            workers[i] = new Thread(mandelbrot::computeRows);
            workers[i].start();
        }

        computeRows();

        for (Thread worker : workers) {
            worker.join();
        }

        BufferedOutputStream out = new BufferedOutputStream(System.out, 1 << 20);
        byte[] header = ("P4\n" + size + " " + size + "\n")
                .getBytes(StandardCharsets.US_ASCII);
        out.write(header);
        out.write(image);
        out.flush();
    }
}