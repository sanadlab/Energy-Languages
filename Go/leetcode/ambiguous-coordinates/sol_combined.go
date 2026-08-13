package main

func ambiguousCoordinates(s string) []string {
	digits := s[1 : len(s)-1]
	n := len(digits)
	res := []string{}
	for i := 1; i < n; i++ {
		left := makeAmbigNums(digits[:i])
		right := makeAmbigNums(digits[i:])
		for _, a := range left {
			for _, b := range right {
				res = append(res, "("+a+", "+b+")")
			}
		}
	}
	return res
}

func makeAmbigNums(d string) []string {
	out := []string{}
	n := len(d)
	if n == 1 {
		out = append(out, d)
		return out
	}
	if d[0] != '0' {
		out = append(out, d)
	}
	for i := 1; i < n; i++ {
		l := d[:i]
		r := d[i:]
		if (l == "0" || l[0] != '0') && r[len(r)-1] != '0' {
			out = append(out, l+"."+r)
		}
	}
	return out
}
