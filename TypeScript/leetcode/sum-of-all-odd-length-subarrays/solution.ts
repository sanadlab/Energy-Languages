function sumOddLengthSubarrays(arr: number[]): number {
    const n = arr.length;
    let total = 0;
    for (let i = 0; i < n; i++) {
        const count = Math.floor(((i + 1) * (n - i) + 1) / 2);
        total += count * arr[i];
    }
    return total;
}
