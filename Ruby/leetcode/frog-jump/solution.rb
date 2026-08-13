# @param {Integer[]} stones
# @return {Boolean}
def can_cross(stones)
  stone_positions = stones.each_with_index.to_h { |pos, i| [pos, i] }
  n = stones.size
  # dp[i] = set of jump sizes that can land on stone i
  dp = Array.new(n) { Set.new }
  dp[0].add(0)

  (0...n).each do |i|
    dp[i].each do |k|
      # next jump can be k-1, k, or k+1 (must be > 0)
      [k - 1, k, k + 1].each do |step|
        next if step <= 0
        next_pos = stones[i] + step
        if stone_positions.key?(next_pos)
          dp[stone_positions[next_pos]].add(step)
        end
      end
    end
  end

  !dp[n - 1].empty?
end