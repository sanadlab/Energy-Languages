from collections import Counter
from typing import List

class Solution:
    def numTriplets(self, nums1: List[int], nums2: List[int]) -> int:
        def count_triplets(arr1, arr2):
            count = 0
            freq = Counter(arr2)
            # For each pair in arr2, count product frequencies
            product_count = Counter()
            n = len(arr2)
            for i in range(n):
                for j in range(i+1, n):
                    product_count[arr2[i]*arr2[j]] += 1
            # For each element in arr1, check if its square is in product_count
            for x in arr1:
                sq = x*x
                count += product_count.get(sq, 0)
            return count
        
        return count_triplets(nums1, nums2) + count_triplets(nums2, nums1)
