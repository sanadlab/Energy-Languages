package main

func friendRequests(n int, restrictions [][]int, requests [][]int) []bool {
    parent := make([]int, n)
    for i := range parent {
        parent[i] = i
    }
    var find func(int) int
    find = func(x int) int {
        for parent[x] != x {
            parent[x] = parent[parent[x]]
            x = parent[x]
        }
        return x
    }
    res := make([]bool, len(requests))
    for idx, req := range requests {
        u, v := req[0], req[1]
        pu, pv := find(u), find(v)
        if pu == pv {
            res[idx] = true
            continue
        }
        ok := true
        for _, r := range restrictions {
            px, py := find(r[0]), find(r[1])
            if (px == pu && py == pv) || (px == pv && py == pu) {
                ok = false
                break
            }
        }
        if ok {
            parent[pu] = pv
            res[idx] = true
        } else {
            res[idx] = false
        }
    }
    return res
}
