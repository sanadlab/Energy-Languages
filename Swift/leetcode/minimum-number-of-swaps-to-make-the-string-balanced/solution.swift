class Solution {
    func minSwaps(_ s: String) -> Int {
        var open_ = 0
        for c in s {
            if c == "[" {
                open_ += 1
            } else if open_ > 0 {
                open_ -= 1
            }
        }
        return (open_ + 1) / 2
    }
}
