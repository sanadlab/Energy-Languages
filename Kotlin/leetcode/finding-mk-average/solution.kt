class MKAverage(m: Int, k: Int) {

    private val mm = m
    private val kk = k
    private val stream = ArrayList<Int>()

    fun addElement(num: Int) {
        stream.add(num)
    }

    fun calculateMKAverage(): Int {
        if (stream.size < mm) return -1
        val last = stream.subList(stream.size - mm, stream.size).sorted()
        val trimmed = last.subList(kk, mm - kk)
        if (trimmed.isEmpty()) return 0
        var sum = 0L
        for (x in trimmed) sum += x
        return (sum / trimmed.size).toInt()
    }

}

/**
 * Your MKAverage object will be instantiated and called as such:
 * var obj = MKAverage(m, k)
 * obj.addElement(num)
 * var param_2 = obj.calculateMKAverage()
 */
