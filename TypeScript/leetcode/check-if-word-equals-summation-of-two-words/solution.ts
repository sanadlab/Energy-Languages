function isSumEqual(firstWord: string, secondWord: string, targetWord: string): boolean {
    const val = (s: string): number => {
        let n = 0;
        for (const c of s) n = n * 10 + (c.charCodeAt(0) - 97);
        return n;
    };
    return val(firstWord) + val(secondWord) === val(targetWord);
}
