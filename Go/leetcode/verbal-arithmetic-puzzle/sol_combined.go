package main

func isSolvable(words []string, result string) bool {
	maxLen := len(result)
	assigned := make([]int, 128)
	for i := range assigned {
		assigned[i] = -1
	}
	usedDigit := make([]bool, 10)
	leading := make([]bool, 128)
	for _, w := range words {
		if len(w) > maxLen {
			return false
		}
		if len(w) > 1 {
			leading[w[0]] = true
		}
	}
	if len(result) > 1 {
		leading[result[0]] = true
	}

	var solve func(col, row, carry int) bool
	solve = func(col, row, carry int) bool {
		if col == maxLen {
			return carry == 0
		}
		if row < len(words) {
			w := words[row]
			if col >= len(w) {
				return solve(col, row+1, carry)
			}
			ch := w[len(w)-1-col]
			if assigned[ch] != -1 {
				return solve(col, row+1, carry)
			}
			for d := 0; d <= 9; d++ {
				if !usedDigit[d] && !(d == 0 && leading[ch]) {
					usedDigit[d] = true
					assigned[ch] = d
					if solve(col, row+1, carry) {
						return true
					}
					usedDigit[d] = false
					assigned[ch] = -1
				}
			}
			return false
		}
		sum := carry
		for _, w := range words {
			if col < len(w) {
				sum += assigned[w[len(w)-1-col]]
			}
		}
		digit := sum % 10
		newCarry := sum / 10
		rch := result[len(result)-1-col]
		if assigned[rch] != -1 {
			if assigned[rch] == digit {
				return solve(col+1, 0, newCarry)
			}
			return false
		}
		if usedDigit[digit] {
			return false
		}
		if digit == 0 && leading[rch] {
			return false
		}
		usedDigit[digit] = true
		assigned[rch] = digit
		if solve(col+1, 0, newCarry) {
			return true
		}
		usedDigit[digit] = false
		assigned[rch] = -1
		return false
	}
	return solve(0, 0, 0)
}
