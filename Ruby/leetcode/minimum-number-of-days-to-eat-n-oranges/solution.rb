def min_days(n)
    memo = {}
    solve = lambda do |x|
        next x if x <= 1
        next memo[x] if memo.key?(x)
        res = 1 + [x % 2 + solve.call(x / 2), x % 3 + solve.call(x / 3)].min
        memo[x] = res
        res
    end
    solve.call(n)
end
