function uncommonFromSentences(s1: string, s2: string): string[] {
    const cnt: Record<string, number> = {};
    for (const w of (s1 + " " + s2).split(" ")) {
        if (w === "") continue;
        cnt[w] = (cnt[w] || 0) + 1;
    }
    return Object.keys(cnt).filter(w => cnt[w] === 1);
}
