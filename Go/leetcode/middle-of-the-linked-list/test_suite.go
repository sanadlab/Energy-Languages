// LC-energy test suite (Go) — middle-of-the-linked-list.
package main

type ListNode struct {
    Val  int
    Next *ListNode
}

func main() {
    h := &ListNode{Val: 1, Next: &ListNode{Val: 2, Next: &ListNode{Val: 3, Next: &ListNode{Val: 4, Next: &ListNode{Val: 5}}}}}
    _ = middleNode(h)
}
