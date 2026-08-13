// LC-energy test suite (Rust) — hardcoded single case.
fn main() {
    let sc = StreamChecker::new(vec!["a".to_string(), "b".to_string(), "c".to_string()]);
    let _ = sc.query('a');
}
