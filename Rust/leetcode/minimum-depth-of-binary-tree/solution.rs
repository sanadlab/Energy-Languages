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
