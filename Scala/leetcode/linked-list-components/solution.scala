object Solution {
    def numComponents(head: ListNode, nums: Array[Int]): Int = {
        val set = scala.collection.mutable.HashSet[Int]()
        for (n <- nums) set += n
        var count = 0
        var prev = false
        var cur = head
        while (cur != null) {
            val isIn = set.contains(cur.x)
            if (isIn && !prev) count += 1
            prev = isIn
            cur = cur.next
        }
        count
    }
}
