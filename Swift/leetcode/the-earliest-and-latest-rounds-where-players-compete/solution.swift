class Solution {
    func earliestAndLatest(_ n: Int, _ firstPlayer: Int, _ secondPlayer: Int) -> [Int] {
        var cache: [[Int]: (Int, Int)] = [:]

        func dp(_ m: Int, _ f0: Int, _ s0: Int) -> (Int, Int) {
            var f = f0, s = s0
            if f > s { swap(&f, &s) }
            let key = [m, f, s]
            if let cached = cache[key] { return cached }
            // The two players meet this round iff they are paired together.
            if f + s == m + 1 {
                cache[key] = (1, 1)
                return (1, 1)
            }
            let newM = (m + 1) / 2
            var groups: [[Int]] = []
            var p = 1
            while p <= m / 2 {
                let q = m + 1 - p
                if f == p || f == q {
                    groups.append([f])          // firstPlayer always wins its match
                } else if s == p || s == q {
                    groups.append([s])          // secondPlayer always wins its match
                } else {
                    groups.append([p, q])       // either side may be chosen to win
                }
                p += 1
            }
            if m % 2 == 1 {
                groups.append([(m + 1) / 2])    // middle player auto-advances
            }
            // cartesian product of the group choices
            var combos: [[Int]] = [[]]
            for g in groups {
                var newCombos: [[Int]] = []
                for combo in combos {
                    for w in g {
                        newCombos.append(combo + [w])
                    }
                }
                combos = newCombos
            }
            var outcomes = Set<[Int]>()
            for combo in combos {
                var belowF = 0, belowS = 0
                for w in combo {
                    if w < f { belowF += 1 }
                    if w < s { belowS += 1 }
                }
                outcomes.insert([belowF + 1, belowS + 1])
            }
            var earliest = Int.max
            var latest = Int.min
            for o in outcomes {
                let (e, l) = dp(newM, o[0], o[1])
                earliest = min(earliest, e + 1)
                latest = max(latest, l + 1)
            }
            let result = (earliest, latest)
            cache[key] = result
            return result
        }

        let (earliest, latest) = dp(n, firstPlayer, secondPlayer)
        return [earliest, latest]
    }
}
