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
