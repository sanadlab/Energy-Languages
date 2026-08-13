func validateBinaryTreeNodes(n int, leftChild []int, rightChild []int) bool {
	m := len(leftChild)
	if len(rightChild) < m {
		m = len(rightChild)
	}
	indeg := make([]int, n)
	for i := 0; i < m; i++ {
		for _, c := range []int{leftChild[i], rightChild[i]} {
			if c != -1 {
				if c < 0 || c >= n {
					return false
				}
				indeg[c]++
				if indeg[c] > 1 {
					return false
				}
			}
		}
	}
	root := -1
	for i := 0; i < n; i++ {
		if indeg[i] == 0 {
			if root != -1 {
				return false
			}
			root = i
		}
	}
	if root == -1 {
		return false
	}
	visited := make([]bool, n)
	stack := []int{root}
	count := 0
	for len(stack) > 0 {
		node := stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		if visited[node] {
			return false
		}
		visited[node] = true
		count++
		if node < m {
			for _, c := range []int{leftChild[node], rightChild[node]} {
				if c != -1 {
					stack = append(stack, c)
				}
			}
		}
	}
	return count == n
}
