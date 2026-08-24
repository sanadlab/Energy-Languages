object Solution {
    def minSteps(n: Int): Int = {
        var steps = 0; var d = 2; var m = n
        while (m > 1) { while (m % d == 0) { steps += d; m /= d }; d += 1 }
        steps
    }
}
