function removePalindromeSub(s: string): number {
    if (s.length === 0) return 0;
    let l = 0, r = s.length - 1;
    while (l < r) {
        if (s[l] !== s[r]) return 2;
        l++; r--;
    }
    return 1;
}
