func getCoprimes(nums []int, edges [][]int) []int {
	n := len(nums)
	ans := make([]int, n)
	for i := range ans {
		ans[i] = -1
	}
	adj := make([][]int, n)
	for _, e := range edges {
		if len(e) < 2 {
			continue
		}
		u, v := e[0], e[1]
		if u >= 0 && u < n && v >= 0 && v < n {
			adj[u] = append(adj[u], v)
			adj[v] = append(adj[v], u)
		}
	}

	gcd := func(a, b int) int {
		for b != 0 {
			a, b = b, a%b
		}
		return a
	}

	// For each value 1..50, values coprime with it.
	coprime := make([][]int, 51)
	for a := 1; a <= 50; a++ {
		for b := 1; b <= 50; b++ {
			if gcd(a, b) == 1 {
				coprime[a] = append(coprime[a], b)
			}
		}
	}

	// Ancestor stacks indexed by VALUE (size 51).
	depthStack := make([][]int, 51)
	nodeStack := make([][]int, 51)
	if n == 0 {
		return ans
	}

	var dfs func(node, parent, depth int)
	dfs = func(node, parent, depth int) {
		val := nums[node]
		bestDepth := -1
		bestNode := -1
		for _, cv := range coprime[val] {
			ds := depthStack[cv]
			if len(ds) > 0 && ds[len(ds)-1] > bestDepth {
				bestDepth = ds[len(ds)-1]
				bestNode = nodeStack[cv][len(nodeStack[cv])-1]
			}
		}
		ans[node] = bestNode
		depthStack[val] = append(depthStack[val], depth)
		nodeStack[val] = append(nodeStack[val], node)
		for _, nb := range adj[node] {
			if nb != parent {
				dfs(nb, node, depth+1)
			}
		}
		depthStack[val] = depthStack[val][:len(depthStack[val])-1]
		nodeStack[val] = nodeStack[val][:len(nodeStack[val])-1]
	}
	dfs(0, -1, 0)
	return ans
}
