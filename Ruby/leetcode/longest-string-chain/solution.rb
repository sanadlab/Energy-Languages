# @param {String[]} words
# @return {Integer}
def longest_str_chain(words)
    words.sort_by!(&:length)
    dp = {}
    best = 1
    words.each do |w|
        cur = 1
        (0...w.length).each do |i|
            pred = w[0...i] + w[(i + 1)..-1]
            if dp.key?(pred) && dp[pred] + 1 > cur
                cur = dp[pred] + 1
            end
        end
        dp[w] = cur
        best = cur if cur > best
    end
    best
end
