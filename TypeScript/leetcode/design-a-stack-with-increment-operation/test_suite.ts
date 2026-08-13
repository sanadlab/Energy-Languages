// LC-energy test suite (TypeScript) — design-a-stack-with-increment-operation.
const _lc_stack = new CustomStack(5);
_lc_stack.push(1); _lc_stack.push(2); _lc_stack.push(3);
_lc_stack.increment(2, 100);
const _lc_r1 = _lc_stack.pop();
const _lc_r2 = _lc_stack.pop();
if (_lc_r1 < 0 && _lc_r2 < 0) console.log("unexpected");
