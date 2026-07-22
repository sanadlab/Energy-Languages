from typing import List

class Solution:
    def countPairs(self, nums: List[int], low: int, high: int) -> int:
        max_bit = max(max(nums), high).bit_length() - 1

        def count_le(limit: int) -> int:
            if limit < 0:
                return 0

            trie = [[-1, -1, 0]]
            total = 0

            def insert(num: int) -> None:
                node = 0
                trie[node][2] += 1
                for b in range(max_bit, -1, -1):
                    bit = (num >> b) & 1
                    if trie[node][bit] == -1:
                        trie[node][bit] = len(trie)
                        trie.append([-1, -1, 0])
                    node = trie[node][bit]
                    trie[node][2] += 1

            def query(num: int) -> int:
                node = 0
                res = 0
                for b in range(max_bit, -1, -1):
                    if node == -1:
                        break

                    num_bit = (num >> b) & 1
                    limit_bit = (limit >> b) & 1

                    if limit_bit == 1:
                        same = trie[node][num_bit]
                        if same != -1:
                            res += trie[same][2]
                        node = trie[node][1 - num_bit]
                    else:
                        node = trie[node][num_bit]

                if node != -1:
                    res += trie[node][2]

                return res

            for num in nums:
                total += query(num)
                insert(num)

            return total

        return count_le(high) - count_le(low - 1)
