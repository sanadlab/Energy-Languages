// LC-energy test suite (Rust) — cousins-in-binary-tree.
// Concatenated with solution.rs at compile time; header at the
// top of _combined.rs declares `pub struct Solution;`.
fn main() {
    let root = Rc::new(RefCell::new(TreeNode::new(1)));
    let n2 = Rc::new(RefCell::new(TreeNode::new(2)));
    let n3 = Rc::new(RefCell::new(TreeNode::new(3)));
    let n4 = Rc::new(RefCell::new(TreeNode::new(4)));
    let n5 = Rc::new(RefCell::new(TreeNode::new(5)));
    n2.borrow_mut().right = Some(n4.clone());
    n3.borrow_mut().right = Some(n5.clone());
    root.borrow_mut().left = Some(n2.clone());
    root.borrow_mut().right = Some(n3.clone());
    let _ = Solution::is_cousins(Some(root), 4, 5);
}
