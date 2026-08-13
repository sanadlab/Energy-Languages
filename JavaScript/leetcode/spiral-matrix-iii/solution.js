var spiralMatrixIII = function(rows, cols, rStart, cStart) {
    const total = rows * cols;
    const res = [];
    let r = rStart, c = cStart;
    if (r >= 0 && r < rows && c >= 0 && c < cols) res.push([r, c]);
    const dr = [0, 1, 0, -1];
    const dc = [1, 0, -1, 0];
    let step = 1, d = 0;
    while (res.length < total) {
        for (let t = 0; t < 2; t++) {
            for (let s = 0; s < step; s++) {
                r += dr[d % 4];
                c += dc[d % 4];
                if (r >= 0 && r < rows && c >= 0 && c < cols) res.push([r, c]);
            }
            d++;
        }
        step++;
    }
    return res;
};
