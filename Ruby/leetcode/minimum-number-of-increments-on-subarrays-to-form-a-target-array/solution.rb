def min_number_operations(target)
    return 0 if target.empty?
    ans = target[0]
    (1...target.length).each do |i|
        ans += target[i] - target[i-1] if target[i] > target[i-1]
    end
    ans
end
