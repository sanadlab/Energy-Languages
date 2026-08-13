/**
 * @param {ListNode} head
 * @param {number[]} nums
 * @return {number}
 */
var numComponents = function(head, nums) {
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
};
