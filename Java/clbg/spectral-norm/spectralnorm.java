import java.util.Arrays;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class spectralnorm {
    private static void multiplyRange(
            double[] input, double[] output, boolean transpose,
            int from, int to) {

        int n = input.length;
        int limit = n - 3;

        for (int i = from; i < to; i++) {
            double denominator =
                    (double) i * (i + 1.0) * 0.5 + (transpose ? 1.0 : i + 1.0);
            double step = i + (transpose ? 2.0 : 1.0);
            double s0 = 0.0;
            double s1 = 0.0;
            double s2 = 0.0;
            double s3 = 0.0;

            int j = 0;
            for (; j < limit; j += 4) {
                s0 += input[j] / denominator;
                s1 += input[j + 1] / (denominator + step);
                s2 += input[j + 2] / (denominator + 2.0 * step + 1.0);
                s3 += input[j + 3] / (denominator + 3.0 * step + 3.0);

                denominator += 4.0 * step + 6.0;
                step += 4.0;
            }

            double sum = (s0 + s1) + (s2 + s3);
            for (; j < n; j++) {
                sum += input[j] / denominator;
                denominator += step;
                step += 1.0;
            }
            output[i] = sum;
        }
    }

    private static void multiply(
            double[] input, double[] output, boolean transpose,
            ExecutorService executor, int workers) throws Exception {

        if (workers == 1) {
            multiplyRange(input, output, transpose, 0, input.length);
            return;
        }

        Future<?>[] tasks = new Future<?>[workers];
        for (int worker = 0; worker < workers; worker++) {
            final int from = (int) ((long) input.length * worker / workers);
            final int to = (int) ((long) input.length * (worker + 1) / workers);
            tasks[worker] = executor.submit(
                    () -> multiplyRange(input, output, transpose, from, to));
        }

        for (Future<?> task : tasks) {
            task.get();
        }
    }

    private static void multiplyAtA(
            double[] input, double[] output, double[] temporary,
            ExecutorService executor, int workers) throws Exception {

        multiply(input, temporary, false, executor, workers);
        multiply(temporary, output, true, executor, workers);
    }

    public static void main(String[] args) throws Exception {
        int n = Integer.parseInt(args[0]);

        double[] u = new double[n];
        double[] v = new double[n];
        double[] temporary = new double[n];
        Arrays.fill(u, 1.0);

        int workers = Math.min(
                Math.min(Runtime.getRuntime().availableProcessors(), 32),
                Math.max(1, n / 128));

        ExecutorService executor =
                workers > 1 ? Executors.newFixedThreadPool(workers) : null;

        try {
            for (int iteration = 0; iteration < 10; iteration++) {
                multiplyAtA(u, v, temporary, executor, workers);
                multiplyAtA(v, u, temporary, executor, workers);
            }

            double vBv = 0.0;
            double vv = 0.0;
            for (int i = 0; i < n; i++) {
                vBv += u[i] * v[i];
                vv += v[i] * v[i];
            }

            System.out.printf(Locale.ROOT, "%.9f%n", Math.sqrt(vBv / vv));
        } finally {
            if (executor != null) {
                executor.shutdown();
            }
        }
    }
}