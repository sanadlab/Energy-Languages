package main

import "sort"

func kWeakestRows(mat [][]int, k int) []int {
	type rc struct{ count, idx int }
	rows := make([]rc, len(mat))
	for i, row := range mat {
		c := 0
		for _, v := range row {
			if v == 1 {
				c++
			}
		}
		rows[i] = rc{c, i}
	}
	sort.Slice(rows, func(a, b int) bool {
		if rows[a].count != rows[b].count {
			return rows[a].count < rows[b].count
		}
		return rows[a].idx < rows[b].idx
	})
	lim := k
	if lim > len(rows) {
		lim = len(rows)
	}
	res := make([]int, 0, lim)
	for i := 0; i < lim; i++ {
		res = append(res, rows[i].idx)
	}
	return res
}
