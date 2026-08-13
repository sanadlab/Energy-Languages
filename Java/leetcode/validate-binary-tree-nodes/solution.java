import java.util.*;
class Solution {
    public boolean validateBinaryTreeNodes(int n, int[] leftChild, int[] rightChild) {
        int m = Math.min(leftChild.length, rightChild.length);
        int[] indeg = new int[n];
        for (int i = 0; i < m; i++) {
            for (int c : new int[]{leftChild[i], rightChild[i]}) {
                if (c != -1) {
                    if (c < 0 || c >= n) return false;
                    if (++indeg[c] > 1) return false;
                }
            }
        }
        int root = -1;
        for (int i = 0; i < n; i++) {
            if (indeg[i] == 0) {
                if (root != -1) return false;
                root = i;
            }
        }
        if (root == -1) return false;
        boolean[] visited = new boolean[n];
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(root);
        int count = 0;
        while (!stack.isEmpty()) {
            int node = stack.pop();
            if (visited[node]) return false;
            visited[node] = true;
            count++;
            if (node < m) {
                for (int c : new int[]{leftChild[node], rightChild[node]}) {
                    if (c != -1) stack.push(c);
                }
            }
        }
        return count == n;
    }
}
