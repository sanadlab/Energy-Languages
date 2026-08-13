// Reference TS solution for design-a-stack-with-increment-operation.
class CustomStack {
    max: number;
    stack: number[] = [];
    inc: number[] = [];
    constructor(maxSize: number) { this.max = maxSize; }
    push(x: number): void {
        if (this.stack.length < this.max) { this.stack.push(x); this.inc.push(0); }
    }
    pop(): number {
        if (this.stack.length === 0) return -1;
        const i = this.stack.length - 1;
        const v = this.stack[i] + this.inc[i];
        if (i > 0) this.inc[i - 1] += this.inc[i];
        this.stack.pop(); this.inc.pop();
        return v;
    }
    increment(k: number, val: number): void {
        const i = Math.min(k, this.stack.length) - 1;
        if (i >= 0) this.inc[i] += val;
    }
}
