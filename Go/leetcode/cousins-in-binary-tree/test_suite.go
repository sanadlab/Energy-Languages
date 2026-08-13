// LC-energy test suite (Go) — cousins-in-binary-tree.
// TreeNode declared here (LC solution.go doesn't define it — just uses
// it). Compiled together with sol_combined.go (solution + package main
// prefix) by the Makefile.
package main

type TreeNode struct {
    Val         int
    Left, Right *TreeNode
}

func main() {
    root := &TreeNode{Val: 1,
        Left:  &TreeNode{Val: 2, Right: &TreeNode{Val: 4}},
        Right: &TreeNode{Val: 3, Right: &TreeNode{Val: 5}},
    }
    _ = isCousins(root, 4, 5)
}
