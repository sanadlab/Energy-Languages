package main

func spiralMatrixIII(rows int, cols int, rStart int, cStart int) [][]int {
    total := rows * cols
    res := [][]int{}
    r, c := rStart, cStart
    if r >= 0 && r < rows && c >= 0 && c < cols {
        res = append(res, []int{r, c})
    }
    dr := []int{0, 1, 0, -1}
    dc := []int{1, 0, -1, 0}
    step, d := 1, 0
    for len(res) < total {
        for t := 0; t < 2; t++ {
            for s := 0; s < step; s++ {
                r += dr[d%4]
                c += dc[d%4]
                if r >= 0 && r < rows && c >= 0 && c < cols {
                    res = append(res, []int{r, c})
                }
            }
            d++
        }
        step++
    }
    return res
}
