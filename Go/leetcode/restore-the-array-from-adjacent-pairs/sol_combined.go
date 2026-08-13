package main

func restoreArray(adjacentPairs [][]int) []int {
    adj := make(map[int][]int)
    for _, p := range adjacentPairs {
        adj[p[0]] = append(adj[p[0]], p[1])
        adj[p[1]] = append(adj[p[1]], p[0])
    }
    n := len(adjacentPairs) + 1
    start := 0
    if len(adjacentPairs) > 0 {
        start = adjacentPairs[0][0]
    }
    for k, nbrs := range adj {
        if len(nbrs) == 1 {
            start = k
            break
        }
    }
    res := []int{start}
    prev, cur := start, start
    hasPrev := false
    for len(res) < n {
        nxt := 0
        found := false
        for _, x := range adj[cur] {
            if !hasPrev || x != prev {
                nxt = x
                found = true
                break
            }
        }
        if !found {
            break
        }
        res = append(res, nxt)
        prev, hasPrev, cur = cur, true, nxt
    }
    return res
}
