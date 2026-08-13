function nextBeautifulNumber(n: number): number {
    for (let x = n + 1; ; x++) {
        const cnt = new Array(10).fill(0);
        let t = x;
        while (t > 0) { cnt[t % 10]++; t = Math.floor(t / 10); }
        let ok = true;
        for (let d = 0; d < 10; d++) {
            if (cnt[d] !== 0 && cnt[d] !== d) { ok = false; break; }
        }
        if (ok) return x;
    }
}
