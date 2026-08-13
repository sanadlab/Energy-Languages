function longestStrChain(words: string[]): number {
    words.sort((a, b) => a.length - b.length);
    const dp = new Map<string, number>();
    let best = 1;
    for (const w of words) {
        let cur = 1;
        for (let i = 0; i < w.length; i++) {
            const pred = w.slice(0, i) + w.slice(i + 1);
            const v = dp.get(pred);
            if (v !== undefined && v + 1 > cur) cur = v + 1;
        }
        dp.set(w, cur);
        if (cur > best) best = cur;
    }
    return best;
}
