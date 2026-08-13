class Solution
  def is_scramble(s1, s2)
    return false unless s1.length == s2.length
    return true if s1 == s2

    n = s1.length
    bytes1 = s1.bytes
    bytes2 = s2.bytes

    pref1 = Array.new(n + 1) { Array.new(26, 0) }
    pref2 = Array.new(n + 1) { Array.new(26, 0) }

    i = 0
    while i < n
      pref1[i + 1] = pref1[i].dup
      pref2[i + 1] = pref2[i].dup
      pref1[i + 1][bytes1[i] - 97] += 1
      pref2[i + 1][bytes2[i] - 97] += 1
      i += 1
    end

    same_counts = lambda do |a, b, len|
      ok = true
      c = 0
      while c < 26
        if pref1[a + len][c] - pref1[a][c] != pref2[b + len][c] - pref2[b][c]
          ok = false
          break
        end
        c += 1
      end
      ok
    end

    memo = {}
    dfs = nil

    dfs = lambda do |a, b, len|
      key = ((a * n + b) * (n + 1)) + len

      if memo.key?(key)
        memo[key]
      else
        equal = true
        k = 0
        while k < len
          if bytes1[a + k] != bytes2[b + k]
            equal = false
            break
          end
          k += 1
        end

        if equal
          memo[key] = true
        elsif !same_counts.call(a, b, len)
          memo[key] = false
        else
          found = false
          split = 1

          while split < len && !found
            if dfs.call(a, b, split) && dfs.call(a + split, b + split, len - split)
              found = true
            elsif dfs.call(a, b + len - split, split) && dfs.call(a + split, b, len - split)
              found = true
            end

            split += 1
          end

          memo[key] = found
        end
      end
    end

    dfs.call(0, 0, n)
  end
end

def is_scramble(s1, s2)
  Solution.new.is_scramble(s1, s2)
end