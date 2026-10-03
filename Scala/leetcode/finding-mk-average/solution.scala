class MKAverage(_m: Int, _k: Int) {

    private val stream = scala.collection.mutable.ArrayBuffer[Int]()

    def addElement(num: Int): Unit = {
        stream += num
    }

    def calculateMKAverage(): Int = {
        if (stream.length < _m) -1
        else {
            val last = stream.takeRight(_m).sorted
            val trimmed = last.slice(_k, _m - _k)
            if (trimmed.isEmpty) 0
            else (trimmed.map(_.toLong).sum / trimmed.length).toInt
        }
    }

}

/**
 * Your MKAverage object will be instantiated and called as such:
 * val obj = new MKAverage(m, k)
 * obj.addElement(num)
 * val param_2 = obj.calculateMKAverage()
 */
