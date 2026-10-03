class Solution {
    func clumsy(_ n: Int) -> Int {
        var stack = [n]
        var op = 0
        var x = n - 1
        while x > 0 {
            if op == 0 {
                stack.append(stack.removeLast() * x)
            } else if op == 1 {
                let top = stack.removeLast()
                stack.append(top / x)
            } else if op == 2 {
                stack.append(x)
            } else {
                stack.append(-x)
            }
            op = (op + 1) % 4
            x -= 1
        }
        return stack.reduce(0, +)
    }
}
