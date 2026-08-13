def min_stickers(stickers, target)
    n = target.length
    full = (1 << n) - 1
    inf = Float::INFINITY
    dp = Array.new(1 << n, inf)
    dp[0] = 0
    cnt = stickers.map do |s|
        c = Array.new(26, 0)
        s.each_char { |ch| c[ch.ord - 97] += 1 }
        c
    end
    (0..full).each do |state|
        next if dp[state] == inf
        cnt.each do |c|
            avail = c.dup
            nxt = state
            (0...n).each do |i|
                if state & (1 << i) == 0
                    idx = target[i].ord - 97
                    if avail[idx] > 0
                        avail[idx] -= 1
                        nxt |= (1 << i)
                    end
                end
            end
            dp[nxt] = dp[state] + 1 if dp[state] + 1 < dp[nxt]
        end
    end
    dp[full] == inf ? -1 : dp[full]
end
