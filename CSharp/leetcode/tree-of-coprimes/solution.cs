using System;
using System.Collections.Generic;

public class Solution {
    int[] nums;
    List<int>[] graph;
    int[] ans;
    // For each value from 1 to 50, store a stack of (node, depth)
    Stack<(int node, int depth)>[] valStacks = new Stack<(int node, int depth)>[51];
    int[] gcdCache = new int[51 * 51]; // cache gcd for pairs to speed up

    int GCD(int a, int b) {
        while (b != 0) {
            int t = b;
            b = a % b;
            a = t;
        }
        return a;
    }

    int GetGCD(int a, int b) {
        int key = a * 51 + b;
        if (gcdCache[key] == 0) {
            gcdCache[key] = GCD(a, b);
            gcdCache[b * 51 + a] = gcdCache[key];
        }
        return gcdCache[key];
    }

    public int[] GetCoprimes(int[] nums, int[][] edges) {
        int n = nums.Length;
        this.nums = nums;
        ans = new int[n];
        for (int i = 0; i < n; i++) ans[i] = -1;

        graph = new List<int>[n];
        for (int i = 0; i < n; i++) graph[i] = new List<int>();
        foreach (var e in edges) {
            graph[e[0]].Add(e[1]);
            graph[e[1]].Add(e[0]);
        }

        for (int i = 1; i <= 50; i++) valStacks[i] = new Stack<(int node, int depth)>();

        DFS(0, -1, 0);

        return ans;
    }

    void DFS(int node, int parent, int depth) {
        int val = nums[node];
        // Find closest ancestor with coprime value
        int bestDepth = -1;
        int bestNode = -1;
        for (int v = 1; v <= 50; v++) {
            if (valStacks[v].Count > 0 && GetGCD(val, v) == 1) {
                var (ancNode, ancDepth) = valStacks[v].Peek();
                if (ancDepth > bestDepth) {
                    bestDepth = ancDepth;
                    bestNode = ancNode;
                }
            }
        }
        ans[node] = bestNode;

        valStacks[val].Push((node, depth));
        foreach (var nxt in graph[node]) {
            if (nxt != parent) {
                DFS(nxt, node, depth + 1);
            }
        }
        valStacks[val].Pop();
    }
}