from typing import List
from collections import Counter

class Solution:
    def groupStrings(self, words: List[str]) -> List[int]:
        counts = Counter()
        
        for word in words:
            mask = 0
            for ch in word:
                mask |= 1 << (ord(ch) - ord('a'))
            counts[mask] += 1
        
        masks = list(counts.keys())
        idx = {mask: i for i, mask in enumerate(masks)}
        n = len(masks)
        
        parent = list(range(n))
        size = [counts[mask] for mask in masks]
        
        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x
        
        def union(a, b):
            ra, rb = find(a), find(b)
            if ra == rb:
                return
            if size[ra] < size[rb]:
                ra, rb = rb, ra
            parent[rb] = ra
            size[ra] += size[rb]
        
        removed = {}
        
        for mask, i in idx.items():
            for b in range(26):
                neighbor = mask ^ (1 << b)
                if neighbor in idx:
                    union(i, idx[neighbor])
            
            x = mask
            while x:
                bit = x & -x
                base = mask ^ bit
                if base in removed:
                    union(i, removed[base])
                else:
                    removed[base] = i
                x ^= bit
        
        groups = 0
        largest = 0
        
        for i in range(n):
            if find(i) == i:
                groups += 1
                largest = max(largest, size[i])
        
        return [groups, largest]
