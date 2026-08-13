package main

// LC-energy test suite (Go) — TreeNode single case.
type TreeNode struct {
    Val   int
    Left  *TreeNode
    Right *TreeNode
}

func main() {
    root := &TreeNode{
        Val:  3,
        Left: &TreeNode{Val: 9},
        Right: &TreeNode{
            Val:   20,
            Left:  &TreeNode{Val: 15},
            Right: &TreeNode{Val: 7},
        },
    }
    _ = minDepth(root)
}
