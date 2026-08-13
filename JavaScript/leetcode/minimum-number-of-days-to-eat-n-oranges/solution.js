var minDays = function(n) {
    const memo = new Map();
    const solve = (x) => {
        if (x <= 1) return x;
        if (memo.has(x)) return memo.get(x);
        const res = 1 + Math.min(x % 2 + solve(Math.floor(x / 2)), x % 3 + solve(Math.floor(x / 3)));
        memo.set(x, res);
        return res;
    };
    return solve(n);
};
