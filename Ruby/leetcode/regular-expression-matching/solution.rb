# @param {String} s
# @param {String} p
# @return {Boolean}
def is_match(s, p)
    m = s.length; n = p.length
    dp = Array.new(m + 1) { Array.new(n + 1, false) }
    dp[m][n] = true
    m.downto(0) do |i|
        (n - 1).downto(0) do |j|
            first = i < m && (p[j] == s[i] || p[j] == '.')
            if j + 1 < n && p[j + 1] == '*'
                dp[i][j] = dp[i][j + 2] || (first && dp[i + 1][j])
            else
                dp[i][j] = first && dp[i + 1][j + 1]
            end
        end
    end
    dp[0][0]
end
