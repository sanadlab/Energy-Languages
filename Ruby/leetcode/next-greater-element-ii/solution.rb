def next_greater_elements(nums)
    n = nums.length
    res = Array.new(n, -1)
    st = []
    (0...2 * n).each do |i|
        cur = nums[i % n]
        while !st.empty? && nums[st[-1]] < cur
            res[st.pop] = cur
        end
        st.push(i) if i < n
    end
    res
end
