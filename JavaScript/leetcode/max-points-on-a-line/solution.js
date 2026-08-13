/**
 * @param {number[][]} points
 * @return {number}
 */
var maxPoints = function(points) {
    const n = points.length;
    if (n <= 2) return n;
    const gcd = (a, b) => {
        while (b !== 0) { const t = b; b = a % b; a = t; }
        return a;
    };
    let best = 1;
    for (let i = 0; i < n; i++) {
        const slopes = new Map();
        for (let j = i + 1; j < n; j++) {
            let dx = points[j][0] - points[i][0];
            let dy = points[j][1] - points[i][1];
            const g = gcd(Math.abs(dx), Math.abs(dy));
            dx = dx / g;
            dy = dy / g;
            if (dx < 0 || (dx === 0 && dy < 0)) { dx = -dx; dy = -dy; }
            const key = dx + ',' + dy;
            const c = (slopes.get(key) || 0) + 1;
            slopes.set(key, c);
            if (c + 1 > best) best = c + 1;
        }
    }
    return best;
};
