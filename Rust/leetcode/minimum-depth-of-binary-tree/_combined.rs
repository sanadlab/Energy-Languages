pub struct Solution;

use std::rc::Rc;
use std::cell::RefCell;

impl Solution {
    pub fn min_depth(root: Option<Rc<RefCell<TreeNode>>>) -> i32 {
        match root {
            None => 0,
            Some(node) => {
                let n = node.borrow();
                match (n.left.clone(), n.right.clone()) {
                    (None, None) => 1,
                    (None, Some(r)) => 1 + Self::min_depth(Some(r)),
                    (Some(l), None) => 1 + Self::min_depth(Some(l)),
                    (Some(l), Some(r)) => {
                        1 + std::cmp::min(Self::min_depth(Some(l)), Self::min_depth(Some(r)))
                    }
                }
            }
        }
    }
}
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
