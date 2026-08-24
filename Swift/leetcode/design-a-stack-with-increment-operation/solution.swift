class CustomStack {
    var stk: [Int]; var inc: [Int]; var maxSize: Int; var sz = 0
    init(_ maxSize: Int) { self.maxSize = maxSize; stk = Array(repeating: 0, count: maxSize); inc = Array(repeating: 0, count: maxSize) }
    func push(_ x: Int) { if sz < maxSize { stk[sz] = x; sz += 1 } }
    func pop() -> Int {
        if sz == 0 { return -1 }
        sz -= 1; let i = sz
        if i > 0 { inc[i-1] += inc[i] }
        let res = stk[i] + inc[i]; inc[i] = 0; return res
    }
    func increment(_ k: Int, _ val: Int) { let lim = min(k, sz); if lim > 0 { inc[lim-1] += val } }
}
