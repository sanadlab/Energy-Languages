from typing import List, Optional

# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next

class Solution:
    def numComponents(self, head: Optional[ListNode], nums: List[int]) -> int:
        selected = set(nums)
        components = 0
        in_component = False

        while head:
            if head.val in selected:
                if not in_component:
                    components += 1
                in_component = True
            else:
                in_component = False
            head = head.next

        return components