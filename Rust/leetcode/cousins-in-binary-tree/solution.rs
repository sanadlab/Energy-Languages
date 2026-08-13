use std::cell::RefCell;
use std::rc::Rc;

#[derive(Debug, PartialEq, Eq)]
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

impl Solution {
    pub fn is_cousins(root: Option<Rc<RefCell<TreeNode>>>, x: i32, y: i32) -> bool {
        fn dfs(
            node: &Option<Rc<RefCell<TreeNode>>>,
            parent: i32,
            depth: i32,
            target: i32,
        ) -> Option<(i32, i32)> {
            if let Some(n) = node {
                let n = n.borrow();
                if n.val == target {
                    return Some((depth, parent));
                }
                if let Some(r) = dfs(&n.left, n.val, depth + 1, target) {
                    return Some(r);
                }
                return dfs(&n.right, n.val, depth + 1, target);
            }
            None
        }
        let a = dfs(&root, i32::MIN, 0, x);
        let b = dfs(&root, i32::MIN, 0, y);
        match (a, b) {
            (Some((dx, px)), Some((dy, py))) => dx == dy && px != py,
            _ => false,
        }
    }
}
