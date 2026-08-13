function numSmallerByFrequency(queries: string[], words: string[]): number[] {
    const f = (s: string): number => {
        let mn = 'z';
        let cnt = 0;
        for (const c of s) {
            if (c < mn) { mn = c; cnt = 1; }
            else if (c === mn) cnt++;
        }
        return cnt;
    };
    const wf = words.map(f);
    return queries.map(q => {
        const fq = f(q);
        return wf.filter(v => v > fq).length;
    });
}
