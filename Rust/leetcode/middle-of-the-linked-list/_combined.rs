pub struct Solution;

// LC-energy test suite (Rust) — middle-of-the-linked-list.
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
    let h = build(&[1, 2, 3, 4, 5]);
    let _ = Solution::middle_node(h);
}
impl Solution {
    pub fn middle_node(head: Option<Box<ListNode>>) -> Option<Box<ListNode>> {
        let mut len = 0;
        let mut p = &head;
        while let Some(node) = p {
            len += 1;
            p = &node.next;
        }
        let mut cur = head;
        for _ in 0..(len / 2) {
            cur = cur.unwrap().next;
        }
        cur
    }
}
