object Solution {
    def judgeCircle(moves: String): Boolean = {
        var x = 0
        var y = 0
        for (move <- moves) {
            move match {
                case 'U' => y += 1
                case 'D' => y -= 1
                case 'R' => x += 1
                case 'L' => x -= 1
                case _   =>
            }
        }
        x == 0 && y == 0
    }
}
