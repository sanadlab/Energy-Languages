import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class binarytrees {
    private static final class Node {
        final Node left;
        final Node right;

        Node(Node left, Node right) {
            this.left = left;
            this.right = right;
        }

        long check() {
            return left == null ? 1L : 1L + left.check() + right.check();
        }
    }

    private static Node build(int depth) {
        if (depth == 0) {
            return new Node(null, null);
        }
        return new Node(build(depth - 1), build(depth - 1));
    }

    private static long stretchCheck(int depth) {
        return build(depth).check();
    }

    public static void main(String[] args) throws Exception {
        final int n = Integer.parseInt(args[0]);
        final int stretchDepth = n + 1;

        StringBuilder output = new StringBuilder();
        output.append("stretch tree of depth ").append(stretchDepth)
              .append("\t check: ").append(stretchCheck(stretchDepth))
              .append('\n');

        final Node longLivedTree = build(n);
        final int groups = n >= 4 ? (n - 4) / 2 + 1 : 0;

        if (groups > 0) {
            int threads = Math.min(groups, Runtime.getRuntime().availableProcessors());
            ExecutorService executor = Executors.newFixedThreadPool(threads);
            List<Future<String>> results = new ArrayList<>(groups);

            try {
                for (int d = 4; d <= n; d += 2) {
                    final int depth = d;
                    results.add(executor.submit(() -> {
                        long iterations = 1L << (n - depth + 4);
                        long checksum = 0;
                        for (long i = 0; i < iterations; i++) {
                            checksum += build(depth).check();
                        }
                        return iterations + "\t trees of depth " + depth
                                + "\t check: " + checksum + "\n";
                    }));
                }

                for (Future<String> result : results) {
                    output.append(result.get());
                }
            } finally {
                executor.shutdown();
            }
        }

        output.append("long lived tree of depth ").append(n)
              .append("\t check: ").append(longLivedTree.check())
              .append('\n');

        System.out.print(output);
    }
}