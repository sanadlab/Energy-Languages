class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def numComponents(self, head, nums):
        s = set(nums)
        count = 0
        prev = False
        while head:
            cur = head.val in s
            if cur and not prev:
                count += 1
            prev = cur
            head = head.next
        return count
