import java.util.*;
import java.util.stream.*;
import java.math.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

class binarytrees {
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

    private static Node buildTree(int depth) {
        if (depth == 0) {
            return new Node(null, null);
        }
        return new Node(buildTree(depth - 1), buildTree(depth - 1));
    }

    private static long stretchCheck(int depth) {
        return buildTree(depth).check();
    }

    public static void main(String[] args) throws Exception {
        final int n = Integer.parseInt(args[0]);

        System.out.println("stretch tree of depth " + (n + 1)
                + "\t check: " + stretchCheck(n + 1));

        final Node longLivedTree = buildTree(n);
        final int groupCount = n >= 4 ? (n - 4) / 2 + 1 : 0;

        if (groupCount > 0) {
            int threads = Math.min(groupCount,
                    Runtime.getRuntime().availableProcessors());
            ExecutorService executor = Executors.newFixedThreadPool(threads);
            List<Future<String>> results = new ArrayList<>(groupCount);

            try {
                for (int d = 4; d <= n; d += 2) {
                    final int depth = d;
                    results.add(executor.submit(() -> {
                        long iterations = 1L << (n - depth + 4);
                        long sum = 0;
                        for (long i = 0; i < iterations; i++) {
                            sum += buildTree(depth).check();
                        }
                        return iterations + "\t trees of depth " + depth
                                + "\t check: " + sum;
                    }));
                }

                for (Future<String> result : results) {
                    System.out.println(result.get());
                }
            } finally {
                executor.shutdown();
            }
        }

        System.out.println("long lived tree of depth " + n
                + "\t check: " + longLivedTree.check());
    }
}