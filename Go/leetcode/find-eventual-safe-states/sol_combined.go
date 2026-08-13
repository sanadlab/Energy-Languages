package main

func eventualSafeNodes(graph [][]int) []int {
	n := len(graph)
	rev := make([][]int, n)
	outdeg := make([]int, n)
	for u := 0; u < n; u++ {
		for _, v := range graph[u] {
			if v >= 0 && v < n {
				rev[v] = append(rev[v], u)
				outdeg[u]++
			}
		}
	}
	queue := []int{}
	for i := 0; i < n; i++ {
		if outdeg[i] == 0 {
			queue = append(queue, i)
		}
	}
	safe := make([]bool, n)
	for len(queue) > 0 {
		v := queue[0]
		queue = queue[1:]
		safe[v] = true
		for _, u := range rev[v] {
			outdeg[u]--
			if outdeg[u] == 0 {
				queue = append(queue, u)
			}
		}
	}
	res := []int{}
	for i := 0; i < n; i++ {
		if safe[i] {
			res = append(res, i)
		}
	}
	return res
}
