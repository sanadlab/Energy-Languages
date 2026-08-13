package main

// Reference Go solution for design-a-stack-with-increment-operation.
type CustomStack struct {
    max   int
    stack []int
    inc   []int
}

func Constructor(maxSize int) CustomStack {
    return CustomStack{max: maxSize, stack: make([]int, 0, maxSize), inc: make([]int, 0, maxSize)}
}
func (s *CustomStack) Push(x int) {
    if len(s.stack) < s.max {
        s.stack = append(s.stack, x); s.inc = append(s.inc, 0)
    }
}
func (s *CustomStack) Pop() int {
    if len(s.stack) == 0 { return -1 }
    i := len(s.stack) - 1
    v := s.stack[i] + s.inc[i]
    if i > 0 { s.inc[i-1] += s.inc[i] }
    s.stack = s.stack[:i]; s.inc = s.inc[:i]
    return v
}
func (s *CustomStack) Increment(k int, val int) {
    i := k
    if i > len(s.stack) { i = len(s.stack) }
    if i > 0 { s.inc[i-1] += val }
}
