class Solution:
    def countPalindromicSubsequences(self, s: str) -> int:
        MOD = 10**9 + 7
        n = len(s)
        arr = [ord(ch) - ord('a') for ch in s]

        prev2 = [[0] * (n + 1) for _ in range(4)]
        prev1 = [[0] * n for _ in range(4)]

        for i, c in enumerate(arr):
            prev1[c][i] = 1

        for length in range(2, n + 1):
            size = n - length + 1
            curr = [[0] * size for _ in range(4)]

            for i in range(size):
                j = i + length - 1
                left = arr[i]
                right = arr[j]

                inner_sum = (
                    prev2[0][i + 1]
                    + prev2[1][i + 1]
                    + prev2[2][i + 1]
                    + prev2[3][i + 1]
                ) % MOD

                for c in range(4):
                    if left == c and right == c:
                        curr[c][i] = (inner_sum + 2) % MOD
                    elif left == c:
                        curr[c][i] = prev1[c][i]
                    elif right == c:
                        curr[c][i] = prev1[c][i + 1]
                    else:
                        curr[c][i] = prev2[c][i + 1]

            prev2, prev1 = prev1, curr

        return sum(prev1[c][0] for c in range(4)) % MOD
