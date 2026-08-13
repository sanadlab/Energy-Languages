func judgeCircle(moves string) bool {
    x, y := 0, 0
    for i := 0; i < len(moves); i++ {
        switch moves[i] {
        case 'U':
            y++
        case 'D':
            y--
        case 'R':
            x++
        case 'L':
            x--
        }
    }
    return x == 0 && y == 0
}
