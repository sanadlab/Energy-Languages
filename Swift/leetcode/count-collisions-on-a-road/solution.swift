class Solution {
    func countCollisions(_ directions: String) -> Int {
        let d = Array(directions)
        let n = d.count
        var i = 0
        while i < n && d[i] == "L" { i += 1 }
        var j = n - 1
        while j >= 0 && d[j] == "R" { j -= 1 }
        var collisions = 0
        if i <= j {
            for k in i...j where d[k] != "S" { collisions += 1 }
        }
        return collisions
    }
}
