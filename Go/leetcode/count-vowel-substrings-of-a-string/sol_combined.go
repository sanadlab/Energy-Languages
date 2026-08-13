package main


func countVowelSubstrings(word string) int {
    result := 0
    state := 0 // Bitmask to track presence of vowels: a=1, e=2, i=4, o=8, u=16
    
    for _, char := range word {
        switch char {
            case 'a': state |= 1
            case 'e': state |= 2
            case 'i': state |= 4
            case 'o': state |= 8
            case 'u': state |= 16
            default: state = 0 // Reset if non-vowel is encountered
        }
        
        if state == 31 { // All vowels are present
            result++
        }
    }
    
    return result
}
