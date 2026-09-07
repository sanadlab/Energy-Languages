import java.util.Arrays;
import java.util.Locale;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

class spectralnorm {
    private static final int POWER_ITERATIONS = 10;

    private static final class Worker extends Thread {
        private final int n;
        private final int start;
        private final int end;
        private final double[] u;
        private final double[] v;
        private final double[] tmp;
        private final CyclicBarrier barrier;

        Worker(int n, int start, int end,
               double[] u, double[] v, double[] tmp,
               CyclicBarrier barrier) {
            this.n = n;
            this.start = start;
            this.end = end;
            this.u = u;
            this.v = v;
            this.tmp = tmp;
            this.barrier = barrier;
        }

        @Override
        public void run() {
            try {
                for (int iteration = 0; iteration < POWER_ITERATIONS; iteration++) {
                    multiplyA(u, tmp, n, start, end);
                    barrier.await();

                    multiplyAt(tmp, v, n, start, end);
                    barrier.await();

                    multiplyA(v, tmp, n, start, end);
                    barrier.await();

                    multiplyAt(tmp, u, n, start, end);
                    barrier.await();
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new RuntimeException(e);
            } catch (BrokenBarrierException e) {
                throw new RuntimeException(e);
            }
        }
    }

    private static void multiplyA(double[] input, double[] output,
                                  int n, int start, int end) {
        for (int i = start; i < end; i++) {
            double denominator = 0.5 * i * (i + 1.0) + i + 1.0;
            double increment = i + 1.0;
            double sum = 0.0;

            for (int j = 0; j < n; j++) {
                sum += input[j] / denominator;
                denominator += increment;
                increment += 1.0;
            }
            output[i] = sum;
        }
    }

    private static void multiplyAt(double[] input, double[] output,
                                   int n, int start, int end) {
        for (int i = start; i < end; i++) {
            double denominator = 0.5 * i * (i + 1.0) + 1.0;
            double increment = i + 2.0;
            double sum = 0.0;

            for (int j = 0; j < n; j++) {
                sum += input[j] / denominator;
                denominator += increment;
                increment += 1.0;
            }
            output[i] = sum;
        }
    }

    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);

        double[] u = new double[n];
        double[] v = new double[n];
        double[] tmp = new double[n];
        Arrays.fill(u, 1.0);

        int processors = Runtime.getRuntime().availableProcessors();
        int workerCount = Math.min(processors, Math.max(1, (n + 15) / 16));
        workerCount = Math.min(workerCount, n);

        CyclicBarrier barrier = new CyclicBarrier(workerCount);
        Worker[] workers = new Worker[workerCount];

        for (int i = 0; i < workerCount; i++) {
            int start = i * n / workerCount;
            int end = (i + 1) * n / workerCount;
            workers[i] = new Worker(n, start, end, u, v, tmp, barrier);
            workers[i].start();
        }

        for (Worker worker : workers) {
            try {
                worker.join();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
        }

        double uv = 0.0;
        double vv = 0.0;
        for (int i = 0; i < n; i++) {
            uv += u[i] * v[i];
            vv += v[i] * v[i];
        }

        System.out.printf(Locale.US, "%.9f%n", Math.sqrt(uv / vv));
    }
}