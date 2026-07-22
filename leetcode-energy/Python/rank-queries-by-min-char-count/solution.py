from bisect import bisect

class Solution:
    def numSmallerByFrequency(self, queries, words):
        def f(s):
            smallest = min(s)
            return s.count(smallest)
        
        words_freq = sorted(f(w) for w in words)
        answer = []
        for q in queries:
            fq = f(q)
            # count how many words have freq > fq
            # use bisect_right to find the first index where fq would be inserted
            # all elements after that index are > fq
            idx = bisect(words_freq, fq)
            answer.append(len(words_freq) - idx)
        return answer
