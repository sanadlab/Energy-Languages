class CustomStack:
    def __init__(self, maxSize):
        self.maxSize = maxSize
        self.stack = []
        self.inc = []

    def push(self, x):
        if len(self.stack) < self.maxSize:
            self.stack.append(x)
            self.inc.append(0)

    def pop(self):
        if not self.stack:
            return -1
        i = len(self.stack) - 1
        v = self.stack[i] + self.inc[i]
        if i > 0:
            self.inc[i - 1] += self.inc[i]
        self.stack.pop()
        self.inc.pop()
        return v

    def increment(self, k, val):
        i = min(k, len(self.stack)) - 1
        if i >= 0:
            self.inc[i] += val
