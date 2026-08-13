# @param {Integer[][]} fruits
# @param {Integer} start_pos
# @param {Integer} k
# @return {Integer}
def max_total_fruits(fruits, start_pos, k)
    cost = lambda do |pos_l, pos_r|
        if pos_r <= start_pos
            start_pos - pos_l
        elsif pos_l >= start_pos
            pos_r - start_pos
        else
            (pos_r - pos_l) + [start_pos - pos_l, pos_r - start_pos].min
        end
    end
    n = fruits.length
    best = 0
    total = 0
    i = 0
    (0...n).each do |j|
        total += fruits[j][1]
        while i <= j && cost.call(fruits[i][0], fruits[j][0]) > k
            total -= fruits[i][1]
            i += 1
        end
        best = total if i <= j && total > best
    end
    best
end
