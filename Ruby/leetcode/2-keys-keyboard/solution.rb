# @param {Integer} n
# @return {Integer}
def min_steps(n)
    res = 0
    d = 2
    while d <= n
        while n % d == 0
            res += d
            n /= d
        end
        d += 1
    end
    res
end
