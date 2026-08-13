def maximum_binary_string(binary)
    n = binary.length
    first = -1
    zeros = 0
    (0...n).each do |i|
        if binary[i] == '0'
            first = i if first == -1
            zeros += 1
        end
    end
    return binary if first == -1
    res = '1' * n
    res[first + zeros - 1] = '0'
    res
end
