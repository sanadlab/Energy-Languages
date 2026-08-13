function maximumBinaryString(binary: string): string {
    const n = binary.length;
    let first = -1, zeros = 0;
    for (let i = 0; i < n; i++) {
        if (binary[i] === '0') { if (first === -1) first = i; zeros++; }
    }
    if (first === -1) return binary;
    const res = new Array(n).fill('1');
    res[first + zeros - 1] = '0';
    return res.join('');
}
