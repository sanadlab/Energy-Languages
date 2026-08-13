# @param {Integer} n
# @return {Integer}
def next_beautiful_number(n)
    x = n + 1
    loop do
        cnt = Array.new(10, 0)
        t = x
        while t > 0
            cnt[t % 10] += 1
            t /= 10
        end
        ok = true
        (0...10).each do |d|
            if cnt[d] != 0 && cnt[d] != d
                ok = false
                break
            end
        end
        return x if ok
        x += 1
    end
end
