function numComponents(head: ListNode | null, nums: number[]): number {
    const s = new Set(nums);
    let count = 0;
    let prev = false;
    while (head) {
        const cur = s.has(head.val);
        if (cur && !prev) count++;
        prev = cur;
        head = head.next;
    }
    return count;
}
// LC-energy test suite (TypeScript) — linked-list-components.
class ListNode {
    val: number; next: ListNode | null;
    constructor(val?: number, next?: ListNode | null) {
        this.val = val ?? 0;
        this.next = next ?? null;
    }
}
const _lc_h = new ListNode(0, new ListNode(1, new ListNode(2, new ListNode(3))));
const _lc_r = numComponents(_lc_h, [0, 1, 3]);
if (_lc_r < 0) console.log(_lc_r);
