object Solution {
    def diStringMatch(s: String): Array[Int] = {
        var lo = 0; var hi = s.length; val res = new Array[Int](s.length + 1)
        for (i <- 0 until s.length) { if (s(i) == 'I') { res(i) = lo; lo += 1 } else { res(i) = hi; hi -= 1 } }
        res(s.length) = lo; res
    }
}
