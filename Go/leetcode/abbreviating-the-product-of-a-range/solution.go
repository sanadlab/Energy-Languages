import "fmt"

func abbreviateProduct(left int, right int) string {
	const SUFMOD int64 = 10000000000000 // 1e13
	var suf int64 = 1
	pre := 1.0
	var c2, c5 int64 = 0, 0
	var extra int64 = 0
	for i := left; i <= right; i++ {
		x := i
		for x%2 == 0 {
			x /= 2
			c2++
		}
		for x%5 == 0 {
			x /= 5
			c5++
		}
		suf = (suf * int64(x)) % SUFMOD
		pre *= float64(i)
		for pre >= 1e15 {
			pre /= 10
			extra++
		}
	}
	C := c2
	if c5 < C {
		C = c5
	}
	r2 := c2 - C
	r5 := c5 - C
	for k := int64(0); k < r2; k++ {
		suf = (suf * 2) % SUFMOD
	}
	for k := int64(0); k < r5; k++ {
		suf = (suf * 5) % SUFMOD
	}
	tmp := pre
	var intdigits int64 = 1
	for tmp >= 10 {
		tmp /= 10
		intdigits++
	}
	Nfull := extra + intdigits
	d := Nfull - C
	if d <= 10 {
		return fmt.Sprintf("%de%d", suf, C)
	}
	lead := pre
	for lead >= 100000 {
		lead /= 10
	}
	for lead < 10000 {
		lead *= 10
	}
	first5 := int64(lead)
	last5 := suf % 100000
	return fmt.Sprintf("%d...%05de%d", first5, last5, C)
}
