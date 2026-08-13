var sortByBits = function(arr) {
    const bits = x => { let c = 0; while (x > 0) { c += x & 1; x >>>= 1; } return c; };
    return arr.slice().sort((a, b) => bits(a) - bits(b) || a - b);
};
