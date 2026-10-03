object Solution {
    def clumsy(n: Int): Int = {
        val stack = scala.collection.mutable.ArrayBuffer[Int](n)
        var op = 0
        var x = n - 1
        while (x > 0) {
            if (op == 0) {
                val t = stack.remove(stack.length - 1)
                stack += t * x
            } else if (op == 1) {
                val t = stack.remove(stack.length - 1)
                stack += t / x
            } else if (op == 2) {
                stack += x
            } else {
                stack += -x
            }
            op = (op + 1) % 4
            x -= 1
        }
        stack.sum
    }
}
