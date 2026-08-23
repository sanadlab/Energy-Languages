class CustomStack(private val maxSize: Int) {
    private val stack = IntArray(maxSize)
    private var size = 0
    fun push(x: Int) { if (size < maxSize) stack[size++] = x }
    fun pop(): Int = if (size == 0) -1 else stack[--size]
    fun increment(k: Int, v: Int) { val n = minOf(k, size); for (i in 0 until n) stack[i] += v }
}
