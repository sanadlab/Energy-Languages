/**
 * Example:
 * var li = ListNode(5)
 * var v = li.`val`
 * Definition for singly-linked list.
 * class ListNode(var `val`: Int) {
 *     var next: ListNode? = null
 * }
 */
class Solution {
    fun numComponents(head: ListNode?, nums: IntArray): Int {
        val set = HashSet<Int>()
        for (n in nums) set.add(n)
        var count = 0
        var prev = false
        var node = head
        while (node != null) {
            val cur = set.contains(node.`val`)
            if (cur && !prev) count++
            prev = cur
            node = node.next
        }
        return count
    }
}
