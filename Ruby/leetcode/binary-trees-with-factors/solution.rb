# @param {Integer[]} arr
# @return {Integer}
def num_factored_binary_trees(arr)
    arr.sort!
    mod = 1_000_000_007
    dp = {}
    ans = 0
    arr.each_with_index do |v, i|
        cnt = 1
        (0...i).each do |j|
            a = arr[j]
            if v % a == 0
                b = v / a
                if dp.key?(b)
                    cnt = (cnt + dp[a] * dp[b]) % mod
                end
            end
        end
        dp[v] = cnt
        ans = (ans + cnt) % mod
    end
    ans
end
