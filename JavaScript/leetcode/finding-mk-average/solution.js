// Reference JS solution for finding-mk-average.
var MKAverage = function(m, k) {
    this.m = m; this.k = k; this.stream = [];
};
MKAverage.prototype.addElement = function(num) { this.stream.push(num); };
MKAverage.prototype.calculateMKAverage = function() {
    if (this.stream.length < this.m) return -1;
    const w = this.stream.slice(-this.m).sort((a, b) => a - b);
    const lo = this.k, hi = this.m - this.k;
    if (hi <= lo) return -1;
    let sum = 0;
    for (let i = lo; i < hi; i++) sum += w[i];
    return Math.floor(sum / (hi - lo));
};
