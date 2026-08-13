package main

func strWithout3a3b(a int, b int) string {
    res := []byte{}
    for a > 0 || b > 0 {
        var writeA bool
        n := len(res)
        if n >= 2 && res[n-1] == res[n-2] {
            writeA = res[n-1] == 'b'
        } else {
            writeA = a >= b
        }
        if writeA {
            if a == 0 {
                break
            }
            res = append(res, 'a')
            a--
        } else {
            if b == 0 {
                break
            }
            res = append(res, 'b')
            b--
        }
    }
    return string(res)
}
