def spiral_matrix_iii(rows, cols, r_start, c_start)
    total = rows * cols
    res = []
    r, c = r_start, c_start
    res << [r, c] if r >= 0 && r < rows && c >= 0 && c < cols
    dr = [0, 1, 0, -1]
    dc = [1, 0, -1, 0]
    step = 1
    d = 0
    while res.length < total
        2.times do
            step.times do
                r += dr[d % 4]
                c += dc[d % 4]
                res << [r, c] if r >= 0 && r < rows && c >= 0 && c < cols
            end
            d += 1
        end
        step += 1
    end
    res
end
