class binarytrees {
    private static final int MIN_DEPTH = 4;

    private static final class Node {
        private final Node left;
        private final Node right;

        Node(Node left, Node right) {
            this.left = left;
            this.right = right;
        }

        long check() {
            if (left == null) {
                return 1;
            }
            return 1 + left.check() + right.check();
        }
    }

    private static Node makeTree(int depth) {
        if (depth <= 0) {
            return new Node(null, null);
        }
        return new Node(makeTree(depth - 1), makeTree(depth - 1));
    }

    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);

        Node stretchTree = makeTree(n + 1);
        System.out.println(
            "stretch tree of depth " + (n + 1) + "\t check: " + stretchTree.check()
        );
        stretchTree = null;

        Node longLivedTree = makeTree(n);

        for (int depth = MIN_DEPTH; depth <= n; depth += 2) {
            long iterations = 1L << (n - depth + MIN_DEPTH);
            long check = 0;

            for (long i = 0; i < iterations; i++) {
                check += makeTree(depth).check();
            }

            System.out.println(
                iterations + "\t trees of depth " + depth + "\t check: " + check
            );
        }

        System.out.println(
            "long lived tree of depth " + n + "\t check: " + longLivedTree.check()
        );
    }
}