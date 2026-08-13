var numSmallerByFrequency = function(queries, words) {
    // Helper function to compute f(s)
    function f(s) {
        let minChar = 'z';
        let count = 0;
        for (let ch of s) {
            if (ch < minChar) {
                minChar = ch;
                count = 1;
            } else if (ch === minChar) {
                count++;
            }
        }
        return count;
    }
    
    // Compute frequency array for words
    const wordFreqs = words.map(f);
    // Sort word frequencies for binary search
    wordFreqs.sort((a,b) => a-b);
    
    // Binary search helper: find first index where wordFreqs[idx] > val
    function upperBound(arr, val) {
        let left = 0, right = arr.length;
        while (left < right) {
            let mid = Math.floor((left + right) / 2);
            if (arr[mid] <= val) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        return left;
    }
    
    const result = [];
    for (let q of queries) {
        let fq = f(q);
        // count how many wordFreqs > fq
        let idx = upperBound(wordFreqs, fq);
        result.push(wordFreqs.length - idx);
    }
    return result;
};