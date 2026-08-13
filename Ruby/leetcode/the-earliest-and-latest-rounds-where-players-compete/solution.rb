# @param {Integer} n
# @param {Integer} first_player
# @param {Integer} second_player
# @return {Integer[]}
def earliest_and_latest(n, first_player, second_player)
    memo = {}
    dp = nil
    dp = lambda do |m, f, s|
        f, s = s, f if f > s
        return [1, 1] if f + s == m + 1
        key = [m, f, s]
        return memo[key] if memo.key?(key)
        new_m = (m + 1) / 2
        groups = []
        (1..(m / 2)).each do |p|
            q = m + 1 - p
            if f == p || f == q
                groups << [f]
            elsif s == p || s == q
                groups << [s]
            else
                groups << [p, q]
            end
        end
        groups << [(m + 1) / 2] if m.odd?
        combos = [[]]
        groups.each do |g|
            nxt = []
            combos.each { |c| g.each { |x| nxt << (c + [x]) } }
            combos = nxt
        end
        outcomes = {}
        combos.each do |combo|
            bf = combo.count { |w| w < f }
            bs = combo.count { |w| w < s }
            outcomes[[bf + 1, bs + 1]] = [bf + 1, bs + 1]
        end
        earliest = Float::INFINITY
        latest = -Float::INFINITY
        outcomes.each_value do |o|
            e, l = dp.call(new_m, o[0], o[1])
            earliest = [earliest, e + 1].min
            latest = [latest, l + 1].max
        end
        res = [earliest, latest]
        memo[key] = res
        res
    end
    dp.call(n, first_player, second_player)
end
