class StreamChecker:
    def __init__(self, words=None):
        self.trie = {}
        self.stream = []
        self.max_len = 0
        if words:
            for w in words:
                node = self.trie
                for ch in reversed(w):
                    node = node.setdefault(ch, {})
                node['$'] = True
                if len(w) > self.max_len:
                    self.max_len = len(w)

    def query(self, letter):
        self.stream.append(letter)
        node = self.trie
        n = len(self.stream)
        for step in range(min(self.max_len, n)):
            ch = self.stream[n - 1 - step]
            if ch not in node:
                return False
            node = node[ch]
            if node.get('$'):
                return True
        return False


Solution = StreamChecker
