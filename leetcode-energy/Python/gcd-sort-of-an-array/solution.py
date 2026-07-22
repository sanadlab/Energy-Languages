from typing import List

class Solution:
    def gcdSort(self, nums: List[int]) -> bool:
        max_num = max(nums)
        
        parent = list(range(max_num + 1))
        rank = [0] * (max_num + 1)
        
        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x
        
        def union(a: int, b: int) -> None:
            ra, rb = find(a), find(b)
            if ra == rb:
                return
            if rank[ra] < rank[rb]:
                parent[ra] = rb
            elif rank[ra] > rank[rb]:
                parent[rb] = ra
            else:
                parent[rb] = ra
                rank[ra] += 1
        
        spf = list(range(max_num + 1))
        for i in range(2, int(max_num ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, max_num + 1, i):
                    if spf[j] == j:
                        spf[j] = i
        
        for num in nums:
            x = num
            while x > 1:
                p = spf[x]
                union(num, p)
                while x % p == 0:
                    x //= p
        
        sorted_nums = sorted(nums)
        for a, b in zip(nums, sorted_nums):
            if find(a) != find(b):
                return False
        
        return True
