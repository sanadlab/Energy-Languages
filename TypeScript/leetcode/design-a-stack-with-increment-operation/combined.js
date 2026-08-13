"use strict";
// Reference TS solution for design-a-stack-with-increment-operation.
class CustomStack {
    constructor(maxSize) {
        this.stack = [];
        this.inc = [];
        this.max = maxSize;
    }
    push(x) {
        if (this.stack.length < this.max) {
            this.stack.push(x);
            this.inc.push(0);
        }
    }
    pop() {
        if (this.stack.length === 0)
            return -1;
        const i = this.stack.length - 1;
        const v = this.stack[i] + this.inc[i];
        if (i > 0)
            this.inc[i - 1] += this.inc[i];
        this.stack.pop();
        this.inc.pop();
        return v;
    }
    increment(k, val) {
        const i = Math.min(k, this.stack.length) - 1;
        if (i >= 0)
            this.inc[i] += val;
    }
}
// LC-energy test suite (TypeScript) — design-a-stack-with-increment-operation.
const _lc_stack = new CustomStack(5);
_lc_stack.push(1);
_lc_stack.push(2);
_lc_stack.push(3);
_lc_stack.increment(2, 100);
const _lc_r1 = _lc_stack.pop();
const _lc_r2 = _lc_stack.pop();
if (_lc_r1 < 0 && _lc_r2 < 0)
    console.log("unexpected");
