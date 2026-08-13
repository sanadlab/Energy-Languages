// LC-energy test suite (Go) — linked-list-components.
package main

type ListNode struct {
    Val  int
    Next *ListNode
}

func main() {
    h := &ListNode{Val: 0, Next: &ListNode{Val: 1, Next: &ListNode{Val: 2, Next: &ListNode{Val: 3}}}}
    _ = numComponents(h, []int{0, 1, 3})
}
