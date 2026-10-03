class Solution {
    func abbreviateProduct(_ left: Int, _ right: Int) -> String {
        // Big-integer product in base 1e9 little-endian limbs.
        let base: UInt64 = 1_000_000_000
        var limbs: [UInt64] = [1]
        var i = left
        while i <= right {
            let m = UInt64(i)
            var carry: UInt64 = 0
            var idx = 0
            while idx < limbs.count {
                let cur = limbs[idx] * m + carry
                limbs[idx] = cur % base
                carry = cur / base
                idx += 1
            }
            while carry > 0 {
                limbs.append(carry % base)
                carry /= base
            }
            i += 1
        }
        // Build full decimal string, most significant limb first.
        var s = String(limbs[limbs.count - 1])
        if limbs.count >= 2 {
            var idx = limbs.count - 2
            while idx >= 0 {
                var chunk = String(limbs[idx])
                while chunk.count < 9 { chunk = "0" + chunk }
                s += chunk
                idx -= 1
            }
        }
        // Strip trailing zeros, counting them.
        let chars = Array(s)
        var end = chars.count
        var c = 0
        while end > 0 && chars[end - 1] == "0" {
            end -= 1
            c += 1
        }
        let digits = Array(chars[0..<end])
        if digits.count <= 10 {
            return "\(String(digits))e\(c)"
        }
        let first5 = String(digits[0..<5])
        let last5 = String(digits[(digits.count - 5)..<digits.count])
        return "\(first5)...\(last5)e\(c)"
    }
}
