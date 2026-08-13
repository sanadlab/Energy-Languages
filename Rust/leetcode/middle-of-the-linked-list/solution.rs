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
