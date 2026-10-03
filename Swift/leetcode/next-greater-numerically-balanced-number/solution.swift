class Solution {
    func nextBeautifulNumber(_ n: Int) -> Int {
        var x = n + 1
        while true {
            var cnt = [Int](repeating: 0, count: 10)
            var t = x
            while t > 0 {
                cnt[t % 10] += 1
                t /= 10
            }
            var ok = true
            for d in 0..<10 {
                if cnt[d] != 0 && cnt[d] != d {
                    ok = false
                    break
                }
            }
            if ok { return x }
            x += 1
        }
    }
}
