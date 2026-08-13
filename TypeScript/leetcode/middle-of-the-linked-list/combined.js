"use strict";
function middleNode(head) {
    let slow = head, fast = head;
    while (fast && fast.next) {
        slow = slow.next;
        fast = fast.next.next;
    }
    return slow;
}
// LC-energy test suite (TypeScript) — middle-of-the-linked-list.
class ListNode {
    constructor(val, next) {
        this.val = val ?? 0;
        this.next = next ?? null;
    }
}
const _lc_h = new ListNode(1, new ListNode(2, new ListNode(3, new ListNode(4, new ListNode(5)))));
const _lc_r = middleNode(_lc_h);
if (_lc_r === null)
    console.log("null");
