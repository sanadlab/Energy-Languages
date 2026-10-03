class Solution {
    func numComponents(_ head: ListNode?, _ nums: [Int]) -> Int {
        let numSet = Set(nums)
        var count = 0
        var node = head
        var inPrev = false
        while let n = node {
            if numSet.contains(n.val) {
                if !inPrev { count += 1 }
                inPrev = true
            } else {
                inPrev = false
            }
            node = n.next
        }
        return count
    }
}
