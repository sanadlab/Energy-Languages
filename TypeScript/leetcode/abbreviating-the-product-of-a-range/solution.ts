function abbreviateProduct(left: number, right: number): string {
    const SUFMOD: bigint = 10000000000000n; // 1e13
    let suf: bigint = 1n;
    let pre: number = 1.0;
    let c2: number = 0, c5: number = 0;
    let extra: number = 0;
    for (let i = left; i <= right; i++) {
        let x: number = i;
        while (x % 2 === 0) { x = x / 2; c2++; }
        while (x % 5 === 0) { x = x / 5; c5++; }
        suf = (suf * BigInt(x)) % SUFMOD;
        pre *= i;
        while (pre >= 1e15) { pre /= 10; extra++; }
    }
    const C: number = Math.min(c2, c5);
    const r2: number = c2 - C, r5: number = c5 - C;
    for (let k = 0; k < r2; k++) suf = (suf * 2n) % SUFMOD;
    for (let k = 0; k < r5; k++) suf = (suf * 5n) % SUFMOD;
    let tmp: number = pre, intdigits: number = 1;
    while (tmp >= 10) { tmp /= 10; intdigits++; }
    const Nfull: number = extra + intdigits;
    const d: number = Nfull - C;
    if (d <= 10) {
        return suf.toString() + "e" + C;
    }
    let lead: number = pre;
    while (lead >= 100000) lead /= 10;
    while (lead < 10000) lead *= 10;
    const first5: number = Math.floor(lead);
    const last5: bigint = suf % 100000n;
    let ls: string = last5.toString();
    while (ls.length < 5) ls = "0" + ls;
    return first5.toString() + "..." + ls + "e" + C;
};
