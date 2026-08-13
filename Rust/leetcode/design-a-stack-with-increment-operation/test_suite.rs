// LC-energy test suite (Rust) — design-a-stack-with-increment-operation.
fn main() {
    let mut s = CustomStack::new(5);
    s.push(1); s.push(2); s.push(3);
    s.increment(2, 100);
    let r1 = s.pop();
    let r2 = s.pop();
    if r1 < 0 && r2 < 0 { println!("unexpected"); }
}
