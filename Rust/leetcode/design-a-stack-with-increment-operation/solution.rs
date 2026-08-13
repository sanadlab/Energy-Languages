// Reference Rust solution for design-a-stack-with-increment-operation.
struct CustomStack {
    max: usize,
    stack: Vec<i32>,
    inc: Vec<i32>,
}
impl CustomStack {
    fn new(max_size: i32) -> Self {
        Self { max: max_size as usize, stack: Vec::new(), inc: Vec::new() }
    }
    fn push(&mut self, x: i32) {
        if self.stack.len() < self.max { self.stack.push(x); self.inc.push(0); }
    }
    fn pop(&mut self) -> i32 {
        if self.stack.is_empty() { return -1; }
        let i = self.stack.len() - 1;
        let v = self.stack[i] + self.inc[i];
        if i > 0 { self.inc[i - 1] += self.inc[i]; }
        self.stack.pop(); self.inc.pop();
        v
    }
    fn increment(&mut self, k: i32, val: i32) {
        let n = std::cmp::min(k as usize, self.stack.len());
        if n > 0 { self.inc[n - 1] += val; }
    }
}
