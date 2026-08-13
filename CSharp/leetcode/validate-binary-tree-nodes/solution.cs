using System.Collections.Generic;

public class Solution {
    public bool ValidateBinaryTreeNodes(int n, int[] leftChild, int[] rightChild) {
        int[] parent = new int[n];
        for (int i = 0; i < n; i++) {
            parent[i] = -1;
        }

        for (int i = 0; i < n; i++) {
            int left = leftChild[i];
            if (left != -1) {
                if (parent[left] != -1) {
                    return false;
                }
                parent[left] = i;
            }
            int right = rightChild[i];
            if (right != -1) {
                if (parent[right] != -1) {
                    return false;
                }
                parent[right] = i;
            }
        }

        int rootCount = 0;
        int root = -1;
        for (int j = 0; j < n; j++) {
            if (parent[j] == -1) {
                rootCount++;
                root = j;
            }
        }
        if (rootCount != 1) {
            return false;
        }

        Queue<int> queue = new Queue<int>();
        queue.Enqueue(root);
        bool[] visited = new bool[n];
        visited[root] = true;
        int count = 1;

        while (queue.Count > 0) {
            int u = queue.Dequeue();
            int left = leftChild[u];
            int right = rightChild[u];
            if (left != -1 && !visited[left]) {
                visited[left] = true;
                count++;
                queue.Enqueue(left);
            }
            if (right != -1 && !visited[right]) {
                visited[right] = true;
                count++;
                queue.Enqueue(right);
            }
        }

        return count == n;
    }
}