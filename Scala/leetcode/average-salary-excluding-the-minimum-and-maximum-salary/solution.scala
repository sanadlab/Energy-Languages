object Solution {
    def average(salary: Array[Int]): Double = {
        var mn = salary(0)
        var mx = salary(0)
        var total = 0
        for (s <- salary) {
            total += s
            if (s < mn) mn = s
            if (s > mx) mx = s
        }
        (total - mn - mx).toDouble / (salary.length - 2)
    }
}
