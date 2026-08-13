/**
 * @param {string} s
 * @return {number[]}
 */
var diStringMatch = function(s) {
    let low = 0, high = s.length;
    const perm = [];
    for (let i = 0; i < s.length; i++) {
        if (s[i] === 'I') {
            perm.push(low++);
        } else {
            perm.push(high--);
        }
    }
    // Add the last remaining number
    perm.push(low);
    return perm;
};