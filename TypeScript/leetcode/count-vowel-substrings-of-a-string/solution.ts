function countVowelSubstrings(word: string): number {
    const vowels = new Set(['a', 'e', 'i', 'o', 'u']);
    let count = 0;
    const n = word.length;
    for (let i = 0; i < n; i++) {
        const seen = new Set<string>();
        for (let j = i; j < n; j++) {
            if (!vowels.has(word[j])) break;
            seen.add(word[j]);
            if (seen.size === 5) count++;
        }
    }
    return count;
}
