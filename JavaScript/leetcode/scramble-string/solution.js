/**
 * @param {string} s1
 * @param {string} s2
 * @return {boolean}
 */
var isScramble = function(s1, s2) {
    if (s1.length !== s2.length) return false;
    const memo = new Map();
    const sortedEqual = (a, b) => {
        const c = new Array(26).fill(0);
        for (let i = 0; i < a.length; i++) {
            c[a.charCodeAt(i) - 97]++;
            c[b.charCodeAt(i) - 97]--;
        }
        return c.every(x => x === 0);
    };
    const helper = (a, b) => {
        if (a === b) return true;
        const key = a + "#" + b;
        if (memo.has(key)) return memo.get(key);
        if (!sortedEqual(a, b)) { memo.set(key, false); return false; }
        const n = a.length;
        let res = false;
        for (let i = 1; i < n; i++) {
            if ((helper(a.slice(0, i), b.slice(0, i)) && helper(a.slice(i), b.slice(i))) ||
                (helper(a.slice(0, i), b.slice(n - i)) && helper(a.slice(i), b.slice(0, n - i)))) {
                res = true;
                break;
            }
        }
        memo.set(key, res);
        return res;
    };
    return helper(s1, s2);
};
