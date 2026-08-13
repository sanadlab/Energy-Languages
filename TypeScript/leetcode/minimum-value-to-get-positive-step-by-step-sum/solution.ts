function minStartValue(nums: number[]): number {
    let prefix = 0, minPrefix = 0;
    for (const x of nums) {
        prefix += x;
        if (prefix < minPrefix) minPrefix = prefix;
    }
    return Math.max(1, 1 - minPrefix);
}
