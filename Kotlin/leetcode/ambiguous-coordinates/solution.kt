class Solution {
    fun ambiguousCoordinates(s: String): List<String> {
        val digits = s.substring(1, s.length - 1)
        val n = digits.length
        val res = ArrayList<String>()
        for (i in 1 until n) {
            for (a in make(digits.substring(0, i))) {
                for (b in make(digits.substring(i))) {
                    res.add("($a, $b)")
                }
            }
        }
        return res
    }

    private fun make(d: String): List<String> {
        val out = ArrayList<String>()
        val n = d.length
        if (n == 1) {
            out.add(d)
            return out
        }
        if (d[0] != '0') {
            out.add(d)
        }
        for (i in 1 until n) {
            val l = d.substring(0, i)
            val r = d.substring(i)
            if ((l == "0" || l[0] != '0') && r[r.length - 1] != '0') {
                out.add(l + "." + r)
            }
        }
        return out
    }
}
