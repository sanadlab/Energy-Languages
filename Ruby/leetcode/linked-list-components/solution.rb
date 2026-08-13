# @param {ListNode} head
# @param {Integer[]} nums
# @return {Integer}
def num_components(head, nums)
    s = {}
    nums.each { |n| s[n] = true }
    count = 0
    prev = false
    while head
        cur = s.key?(head.val)
        count += 1 if cur && !prev
        prev = cur
        head = head.next
    end
    count
end
