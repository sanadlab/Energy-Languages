// LC-energy test suite (TypeScript) — finding-mk-average.
const _lc_obj = new MKAverage(5, 1);
[1,2,3,4,5,6,7,8,9,10].forEach(v => _lc_obj.addElement(v));
const _lc_r = _lc_obj.calculateMKAverage();
if (_lc_r < -1) console.log(_lc_r);
