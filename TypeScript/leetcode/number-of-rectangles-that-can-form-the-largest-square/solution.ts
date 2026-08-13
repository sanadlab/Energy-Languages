function countGoodRectangles(rectangles: number[][]): number {
    let maxLen = 0, count = 0;
    for (const r of rectangles) {
        const side = Math.min(r[0], r[1]);
        if (side > maxLen) { maxLen = side; count = 1; }
        else if (side === maxLen) { count++; }
    }
    return count;
}
