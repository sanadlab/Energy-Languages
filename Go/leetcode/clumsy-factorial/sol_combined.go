package main

func clumsy(n int) int {
	stack := []int{n}
	op := 0
	for x := n - 1; x >= 1; x-- {
		switch op {
		case 0:
			stack[len(stack)-1] *= x
		case 1:
			stack[len(stack)-1] /= x
		case 2:
			stack = append(stack, x)
		case 3:
			stack = append(stack, -x)
		}
		op = (op + 1) % 4
	}
	sum := 0
	for _, v := range stack {
		sum += v
	}
	return sum
}
