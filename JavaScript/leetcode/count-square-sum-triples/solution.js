/**
 * @param {number} n
 * @return {number}
 */
var countTriples = function(n) {
    let count = 0;
    for (let a = 1; a < n; a++) {
        for (let b = a; b < n; b++) { // Start from 'a' to avoid duplicate triples
            const c2 = a * a + b * b;
            const c = Math.sqrt(c2);
            if (c <= n && c % 1 === 0) count++;
        }
    }
    return count * 2; // Each triple (a, b, c) can be in two orders
};