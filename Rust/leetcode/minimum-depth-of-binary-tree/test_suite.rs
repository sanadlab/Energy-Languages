// LC-energy test suite (Rust) — TreeNode single case.
// `use std::rc::Rc; use std::cell::RefCell;` come from solution.rs (same module).
pub struct TreeNode {
    pub val: i32,
    pub left: Option<Rc<RefCell<TreeNode>>>,
    pub right: Option<Rc<RefCell<TreeNode>>>,
}

impl TreeNode {
    #[inline]
    pub fn new(val: i32) -> Self {
        TreeNode { val, left: None, right: None }
    }
}

fn mk(val: i32, left: Option<Rc<RefCell<TreeNode>>>, right: Option<Rc<RefCell<TreeNode>>>) -> Option<Rc<RefCell<TreeNode>>> {
    let mut n = TreeNode::new(val);
    n.left = left;
    n.right = right;
    Some(Rc::new(RefCell::new(n)))
}

fn main() {
    let root = mk(3, mk(9, None, None), mk(20, mk(15, None, None), mk(7, None, None)));
    let _ = Solution::min_depth(root);
}
