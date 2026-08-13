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
