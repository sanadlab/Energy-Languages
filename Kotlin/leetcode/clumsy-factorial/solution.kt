class Solution {
    fun clumsy(n: Int): Int {
        val stack = ArrayDeque<Int>()
        stack.addLast(n)
        var op = 0
        var x = n - 1
        while (x > 0) {
            when (op) {
                0 -> stack.addLast(stack.removeLast() * x)
                1 -> {
                    val top = stack.removeLast()
                    stack.addLast(top / x)
                }
                2 -> stack.addLast(x)
                else -> stack.addLast(-x)
            }
            op = (op + 1) % 4
            x--
        }
        return stack.sum()
    }
}
