class Solution
  def is_match(s, p)
    n = s.length
    m = p.length

    dp = Array.new(n + 1) { Array.new(m + 1) { false } }

    dp[0][0] = true

    for j in 1..m
      if p[j-1] == '*'
        dp[0][j] = dp[0][j-1]
      else
        dp[0][j] = false
      end
    end

    for i in 1..n
      for j in 1..m
        if p[j-1] == '*'
          dp[i][j] = dp[i][j-1] || dp[i-1][j]
        else
          if p[j-1] == '?' || s[i-1] == p[j-1]
            dp[i][j] = dp[i-1][j-1]
          else
            dp[i][j] = false
          end
        end
      end
    end

    dp[n][m]
  end
end