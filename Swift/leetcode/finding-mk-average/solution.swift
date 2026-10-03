
class MKAverage {

    let m: Int
    let k: Int
    var stream: [Int] = []

    init(_ m: Int, _ k: Int) {
        self.m = m
        self.k = k
    }

    func addElement(_ num: Int) {
        stream.append(num)
    }

    func calculateMKAverage() -> Int {
        if stream.count < m { return -1 }
        let last = Array(stream.suffix(m)).sorted()
        let trimmed = last[k..<(m - k)]
        if trimmed.isEmpty { return 0 }
        return trimmed.reduce(0, +) / trimmed.count
    }
}

/**
 * Your MKAverage object will be instantiated and called as such:
 * let obj = MKAverage(m, k)
 * obj.addElement(num)
 * let ret_2: Int = obj.calculateMKAverage()
 */
