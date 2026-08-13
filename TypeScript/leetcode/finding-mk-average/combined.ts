// Reference TS solution for finding-mk-average.
class MKAverage {
    m: number; k: number;
    stream: number[] = [];
    constructor(m: number, k: number) { this.m = m; this.k = k; }
    addElement(num: number): void { this.stream.push(num); }
    calculateMKAverage(): number {
        if (this.stream.length < this.m) return -1;
        const w = this.stream.slice(-this.m).sort((a, b) => a - b);
        const lo = this.k, hi = this.m - this.k;
        if (hi <= lo) return -1;
        let sum = 0;
        for (let i = lo; i < hi; i++) sum += w[i];
        return Math.floor(sum / (hi - lo));
    }
}
// LC-energy test suite (TypeScript) — finding-mk-average.
const _lc_obj = new MKAverage(5, 1);
[1,2,3,4,5,6,7,8,9,10].forEach(v => _lc_obj.addElement(v));
const _lc_r = _lc_obj.calculateMKAverage();
if (_lc_r < -1) console.log(_lc_r);
