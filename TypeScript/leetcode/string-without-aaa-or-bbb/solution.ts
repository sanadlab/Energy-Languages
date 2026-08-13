function strWithout3a3b(a: number, b: number): string {
    const res: string[] = [];
    while (a > 0 || b > 0) {
        let writeA: boolean;
        const n = res.length;
        if (n >= 2 && res[n-1] === res[n-2]) writeA = res[n-1] === 'b';
        else writeA = a >= b;
        if (writeA) {
            if (a === 0) break;
            res.push('a'); a--;
        } else {
            if (b === 0) break;
            res.push('b'); b--;
        }
    }
    return res.join('');
}
