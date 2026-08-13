package main

func canBeTypedWords(text string, brokenLetters string) int {
    var broken [26]bool
    for _, c := range brokenLetters {
        if c >= 'a' && c <= 'z' {
            broken[c-'a'] = true
        }
    }
    count := 0
    ok := true
    for _, c := range text {
        if c == ' ' {
            if ok {
                count++
            }
            ok = true
        } else if c >= 'a' && c <= 'z' && broken[c-'a'] {
            ok = false
        }
    }
    if ok {
        count++
    }
    return count
}
