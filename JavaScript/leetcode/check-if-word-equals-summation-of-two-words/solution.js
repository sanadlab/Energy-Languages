/**
 * @param {string} firstWord
 * @param {string} secondWord
 * @param {string} targetWord
 * @return {boolean}
 */
var isSumEqual = function(firstWord, secondWord, targetWord) {
    const val = s => {
        let n = 0;
        for (const c of s) n = n * 10 + (c.charCodeAt(0) - 97);
        return n;
    };
    return val(firstWord) + val(secondWord) === val(targetWord);
};
