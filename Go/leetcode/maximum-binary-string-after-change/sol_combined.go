package main

func maximumBinaryString(binary string) string {
    n := len(binary)
    first := -1
    zeros := 0
    for i := 0; i < n; i++ {
        if binary[i] == '0' {
            if first == -1 { first = i }
            zeros++
        }
    }
    if first == -1 { return binary }
    res := make([]byte, n)
    for i := range res { res[i] = '1' }
    res[first+zeros-1] = '0'
    return string(res)
}
