object Solution {
    def sortByBits(arr: Array[Int]): Array[Int] = {
        arr.sortBy(x => (Integer.bitCount(x), x))
    }
}
