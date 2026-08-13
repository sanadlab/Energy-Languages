// Reference JS solution for design-a-stack-with-increment-operation.
var CustomStack = function(maxSize) {
    this.max = maxSize;
    this.stack = [];
    this.inc = [];
};
CustomStack.prototype.push = function(x) {
    if (this.stack.length < this.max) { this.stack.push(x); this.inc.push(0); }
};
CustomStack.prototype.pop = function() {
    if (this.stack.length === 0) return -1;
    const i = this.stack.length - 1;
    const v = this.stack[i] + this.inc[i];
    if (i > 0) this.inc[i - 1] += this.inc[i];
    this.stack.pop(); this.inc.pop();
    return v;
};
CustomStack.prototype.increment = function(k, val) {
    const i = Math.min(k, this.stack.length) - 1;
    if (i >= 0) this.inc[i] += val;
};
