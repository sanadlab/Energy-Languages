// LC-energy test suite (TypeScript) — middle-of-the-linked-list.
class ListNode {
    val: number; next: ListNode | null;
    constructor(val?: number, next?: ListNode | null) {
        this.val = val ?? 0;
        this.next = next ?? null;
    }
}
const _lc_h = new ListNode(1, new ListNode(2, new ListNode(3, new ListNode(4, new ListNode(5)))));
const _lc_r = middleNode(_lc_h);
if (_lc_r === null) console.log("null");
