object Solution {
    def minSwaps(s: String): Int = {
        var open = 0
        for (c <- s) {
            if (c == '[') open += 1
            else if (open > 0) open -= 1
        }
        (open + 1) / 2
    }
}
