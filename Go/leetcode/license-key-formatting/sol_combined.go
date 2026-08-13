package main

func licenseKeyFormatting(s string, k int) string {
    // Remove dashes and convert to uppercase
    filtered := make([]byte, 0, len(s))
    for i := 0; i < len(s); i++ {
        if s[i] != '-' {
            if s[i] >= 'a' && s[i] <= 'z' {
                filtered = append(filtered, s[i]-'a'+'A')
            } else {
                filtered = append(filtered, s[i])
            }
        }
    }

    n := len(filtered)
    if n == 0 {
        return ""
    }

    // Calculate the size of the first group
    firstGroupLen := n % k
    if firstGroupLen == 0 {
        firstGroupLen = k
    }

    res := make([]byte, 0, n + n/k) // extra space for dashes

    // Append first group
    res = append(res, filtered[:firstGroupLen]...)

    // Append remaining groups with dashes
    for i := firstGroupLen; i < n; i += k {
        res = append(res, '-')
        res = append(res, filtered[i:i+k]...)
    }

    return string(res)
}
