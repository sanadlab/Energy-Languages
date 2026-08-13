function ambiguousCoordinates(s: string): string[] {
    const digits = s.substring(1, s.length - 1);
    const n = digits.length;
    const res: string[] = [];
    const make = (d: string): string[] => {
        const out: string[] = [];
        const m = d.length;
        if (m === 1) {
            out.push(d);
            return out;
        }
        if (d[0] !== '0') out.push(d);
        for (let i = 1; i < m; i++) {
            const l = d.substring(0, i);
            const r = d.substring(i);
            if ((l === '0' || l[0] !== '0') && r[r.length - 1] !== '0') out.push(l + '.' + r);
        }
        return out;
    };
    for (let i = 1; i < n; i++) {
        const left = make(digits.substring(0, i));
        const right = make(digits.substring(i));
        for (const a of left)
            for (const b of right)
                res.push('(' + a + ', ' + b + ')');
    }
    return res;
}
