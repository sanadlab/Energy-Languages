class Solution {
    func checkStraightLine(_ coordinates: [[Int]]) -> Bool {
        let dx = coordinates[1][0] - coordinates[0][0]
        let dy = coordinates[1][1] - coordinates[0][1]
        var i = 2
        while i < coordinates.count {
            let xDiff = coordinates[i][0] - coordinates[0][0]
            let yDiff = coordinates[i][1] - coordinates[0][1]
            if dx * yDiff != dy * xDiff {
                return false
            }
            i += 1
        }
        return true
    }
}
