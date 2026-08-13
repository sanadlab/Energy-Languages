def min_swaps(s)
    open = 0
    s.each_char do |c|
        if c == '['
            open += 1
        elsif open > 0
            open -= 1
        end
    end
    (open + 1) / 2
end
