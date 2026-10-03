class Solution {
    func maximumBeauty(_ flowers: [Int], _ newFlowers: Int, _ target: Int, _ full: Int, _ partial: Int) -> Int {
        let n = flowers.count
        if n == 0 { return 0 }
        let fl = flowers.map { min($0, target) }.sorted()
        var pre = [Int](repeating: 0, count: n + 1)
        for i in 0..<n {
            pre[i + 1] = pre[i] + fl[i]
        }
        if fl[0] == target { return full * n }

        func bisectLeft(_ x: Int, _ lo0: Int, _ hi0: Int) -> Int {
            var lo = lo0
            var hi = hi0
            while lo < hi {
                let mid = (lo + hi) / 2
                if fl[mid] < x { lo = mid + 1 } else { hi = mid }
            }
            return lo
        }

        var ans = 0
        var i = n
        while i >= 0 {
            let costComplete = target * (n - i) - (pre[n] - pre[i])
            if costComplete > newFlowers {
                i -= 1
                continue
            }
            let rem = newFlowers - costComplete
            if i == 0 {
                ans = max(ans, full * (n - i))
                i -= 1
                continue
            }
            var lo = 0
            var hi = target - 1
            var bestMin = 0
            while lo <= hi {
                let v = (lo + hi) / 2
                let k = bisectLeft(v, 0, i)
                let cost = v * k - pre[k]
                if cost <= rem {
                    bestMin = v
                    lo = v + 1
                } else {
                    hi = v - 1
                }
            }
            ans = max(ans, full * (n - i) + bestMin * partial)
            i -= 1
        }
        return ans
    }
}
