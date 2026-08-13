function countTriples(n: number): number {
    let count = 0;
    for (let a = 1; a <= n; a++) {
        for (let b = 1; b <= n; b++) {
            const c2 = a * a + b * b;
            const c = Math.round(Math.sqrt(c2));
            if (c >= 1 && c <= n && c * c === c2) count++;
        }
    }
    return count;
}
