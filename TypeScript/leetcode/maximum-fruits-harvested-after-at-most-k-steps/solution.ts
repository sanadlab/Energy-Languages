function maxTotalFruits(fruits: number[][], startPos: number, k: number): number {
    const cost = (posL: number, posR: number): number => {
        if (posR <= startPos) return startPos - posL;
        if (posL >= startPos) return posR - startPos;
        return (posR - posL) + Math.min(startPos - posL, posR - startPos);
    };
    const n = fruits.length;
    let best = 0, sum = 0, i = 0;
    for (let j = 0; j < n; j++) {
        sum += fruits[j][1];
        while (i <= j && cost(fruits[i][0], fruits[j][0]) > k) {
            sum -= fruits[i][1];
            i++;
        }
        if (i <= j && sum > best) best = sum;
    }
    return best;
}
