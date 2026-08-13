func numComponents(head *ListNode, nums []int) int {
	s := make(map[int]bool)
	for _, n := range nums {
		s[n] = true
	}
	count := 0
	prev := false
	for head != nil {
		cur := s[head.Val]
		if cur && !prev {
			count++
		}
		prev = cur
		head = head.Next
	}
	return count
}
