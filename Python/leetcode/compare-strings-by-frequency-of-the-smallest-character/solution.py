class Solution:
    def numSmallerByFrequency(self, queries: List[str], words: List[str]) -> List[int]:
        # Helper function to calculate f(s)
        def f(s):
            min_char = min(s)
            return s.count(min_char)

        # Calculate frequencies for all words and sort them
        word_freqs = sorted([f(word) for word in words])

        result = []
        for query in queries:
            q_freq = f(query)
            # Use binary search to find the number of words with frequency > q_freq
            idx = self.binary_search(word_freqs, q_freq + 1)
            result.append(len(words) - idx)

        return result

    def binary_search(self, arr, target):
        left, right = 0, len(arr) - 1
        while left <= right:
            mid = (left + right) // 2
            if arr[mid] < target:
                left = mid + 1
            else:
                right = mid - 1
        return left

# Example usage:
# solution = Solution()
# queries = ["cbd"]
# words = ["zaaaz"]
# print(solution.numSmallerByFrequency(queries, words))  # Output: [1]