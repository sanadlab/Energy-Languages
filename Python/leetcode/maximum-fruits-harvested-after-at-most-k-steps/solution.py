class Solution:
    def maxTotalFruits(self, fruits, startPos, k):
        def cost(pos_l, pos_r):
            if pos_r <= startPos:
                return startPos - pos_l
            if pos_l >= startPos:
                return pos_r - startPos
            return (pos_r - pos_l) + min(startPos - pos_l, pos_r - startPos)

        n = len(fruits)
        best = 0
        total = 0
        i = 0
        for j in range(n):
            total += fruits[j][1]
            while i <= j and cost(fruits[i][0], fruits[j][0]) > k:
                total -= fruits[i][1]
                i += 1
            if i <= j and total > best:
                best = total
        return best
