class Solution:
    def __init__(self, m=0, k=0):
        self.m = m
        self.k = k
        self.stream = []

    def addElement(self, num):
        self.stream.append(num)

    def calculateMKAverage(self):
        if len(self.stream) < self.m:
            return -1
        last = sorted(self.stream[-self.m:])
        trimmed = last[self.k:self.m - self.k]
        if not trimmed:
            return 0
        return sum(trimmed) // len(trimmed)
