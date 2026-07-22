from typing import List

class Solution:
    def largestComponentSize(self, nums: List[int]) -> int:
        n = len(nums)
        
        parent = list(range(n))
        size = [1] * n
        
        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x
        
        def union(a: int, b: int) -> int:
            ra, rb = find(a), find(b)
            if ra == rb:
                return size[ra]
            if size[ra] < size[rb]:
                ra, rb = rb, ra
            parent[rb] = ra
            size[ra] += size[rb]
            return size[ra]
        
        max_num = max(nums)
        spf = list(range(max_num + 1))
        
        for i in range(2, int(max_num ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, max_num + 1, i):
                    if spf[j] == j:
                        spf[j] = i
        
        prime_owner = {}
        answer = 1
        
        for i, num in enumerate(nums):
            x = num
            while x > 1:
                p = spf[x]
                if p in prime_owner:
                    answer = max(answer, union(i, prime_owner[p]))
                else:
                    prime_owner[p] = i
                
                while x % p == 0:
                    x //= p
        
        return answer
