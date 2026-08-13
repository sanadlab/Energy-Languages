var minSwaps = function(s) {
    let open = 0;
    for (const c of s) {
        if (c === '[') open++;
        else if (open > 0) open--;
    }
    return Math.floor((open + 1) / 2);
};
