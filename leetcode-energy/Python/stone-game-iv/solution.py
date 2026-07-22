class Solution:
    def winnerSquareGame(self, n: int) -> bool:
        squares = [i * i for i in range(1, int(n ** 0.5) + 1)]
        dp = bytearray(n + 1)

        for stones in range(1, n + 1):
            for sq in squares:
                if sq > stones:
                    break
                if dp[stones - sq] == 0:
                    dp[stones] = 1
                    break

        return bool(dp[n])
