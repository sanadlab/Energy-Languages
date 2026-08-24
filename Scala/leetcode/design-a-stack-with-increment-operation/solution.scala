class CustomStack(_maxSize: Int) {
    val stk = new Array[Int](_maxSize); val inc = new Array[Int](_maxSize); var sz = 0
    def push(x: Int): Unit = { if (sz < _maxSize) { stk(sz) = x; sz += 1 } }
    def pop(): Int = {
        if (sz == 0) return -1
        sz -= 1; val i = sz
        if (i > 0) inc(i - 1) += inc(i)
        val res = stk(i) + inc(i); inc(i) = 0; res
    }
    def increment(k: Int, `val`: Int): Unit = { val lim = math.min(k, sz); if (lim > 0) inc(lim - 1) += `val` }
}
