def sum_odd_length_subarrays(arr)
    n = arr.length
    total = 0
    (0...n).each do |i|
        count = ((i + 1) * (n - i) + 1) / 2
        total += count * arr[i]
    end
    total
end
