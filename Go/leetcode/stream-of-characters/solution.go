type trieNode struct {
    next [26]*trieNode
    word bool
}

type StreamChecker struct {
    root   *trieNode
    stream []byte
    maxLen int
}

func Constructor(words []string) StreamChecker {
    root := &trieNode{}
    maxLen := 0
    for _, w := range words {
        node := root
        for i := len(w) - 1; i >= 0; i-- {
            c := w[i] - 'a'
            if node.next[c] == nil {
                node.next[c] = &trieNode{}
            }
            node = node.next[c]
        }
        node.word = true
        if len(w) > maxLen {
            maxLen = len(w)
        }
    }
    return StreamChecker{root: root, stream: []byte{}, maxLen: maxLen}
}

func (this *StreamChecker) Query(letter byte) bool {
    this.stream = append(this.stream, letter)
    node := this.root
    n := len(this.stream)
    for step := 0; step < this.maxLen && step < n; step++ {
        c := this.stream[n-1-step] - 'a'
        if node.next[c] == nil {
            return false
        }
        node = node.next[c]
        if node.word {
            return true
        }
    }
    return false
}
