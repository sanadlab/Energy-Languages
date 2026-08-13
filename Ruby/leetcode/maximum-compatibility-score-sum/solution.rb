def max_compatibility_sum(students, mentors)
    m = students.length
    n = m > 0 ? students[0].length : 0
    score = Array.new(m) { Array.new(m, 0) }
    (0...m).each do |i|
        (0...m).each do |j|
            (0...n).each do |k|
                score[i][j] += 1 if students[i][k] == mentors[j][k]
            end
        end
    end
    dp = Array.new(1 << m, 0)
    (0...(1 << m)).each do |mask|
        i = mask.to_s(2).count('1')
        next if i >= m
        (0...m).each do |j|
            next if mask[j] == 1
            nm = mask | (1 << j)
            val = dp[mask] + score[i][j]
            dp[nm] = val if val > dp[nm]
        end
    end
    dp[(1 << m) - 1]
end
