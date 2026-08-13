var strWithout3a3b = function(a, b) {
    const res = [];
    while (a > 0 || b > 0) {
        let writeA;
        const n = res.length;
        if (n >= 2 && res[n-1] === res[n-2]) writeA = res[n-1] === 'b';
        else writeA = a >= b;
        if (writeA) {
            if (a === 0) break;
            res.push('a'); a--;
        } else {
            if (b === 0) break;
            res.push('b'); b--;
        }
    }
    return res.join('');
};
