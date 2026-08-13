pub struct Solution;

impl Solution {
    pub fn suggested_products(products: Vec<String>, search_word: String) -> Vec<Vec<String>> {
        let mut products = products;
        products.sort();
        let mut result = Vec::new();
        for i in 0..search_word.len() {
            let prefix = &search_word[0..i + 1];
            let mut suggestions = Vec::new();
            for product in &products {
                if product.starts_with(prefix) {
                    suggestions.push(product.clone());
                    if suggestions.len() == 3 {
                        break;
                    }
                }
            }
            result.push(suggestions);
        }
        result
    }
}// LC-energy test suite (Rust) — hardcoded single case.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let _ = Solution::suggested_products(vec![String::from("a"),String::from("b"),String::from("c")], String::from("abcde"));
}
