pub struct Solution;

// LC-energy test suite (Rust) — linked-list-components.
// Concatenated with solution.rs at compile time; Makefile prepends
// `pub struct Solution;` header + this file provides the ListNode
// helper used by solution.rs's impl signature.

#[derive(PartialEq, Eq, Clone, Debug)]
pub struct ListNode {
    pub val: i32,
    pub next: Option<Box<ListNode>>,
}
impl ListNode {
    pub fn new(v: i32) -> Self { ListNode { val: v, next: None } }
}
fn build(vs: &[i32]) -> Option<Box<ListNode>> {
    let mut head: Option<Box<ListNode>> = None;
    for &v in vs.iter().rev() {
        let mut n = ListNode::new(v); n.next = head; head = Some(Box::new(n));
    }
    head
}
fn main() {
    let head = build(&[0, 1, 2, 3]);
    let _ = Solution::num_components(head, vec![0, 1, 3]);
}
impl Solution {
    pub fn num_components(head: Option<Box<ListNode>>, nums: Vec<i32>) -> i32 {
        use std::collections::HashSet;
        let set: HashSet<i32> = nums.into_iter().collect();
        let mut count = 0;
        let mut prev = false;
        let mut cur = &head;
        while let Some(node) = cur {
            let inset = set.contains(&node.val);
            if inset && !prev {
                count += 1;
            }
            prev = inset;
            cur = &node.next;
        }
        count
    }
}
