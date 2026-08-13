def str_without3a3b(a, b)
    res = []
    while a > 0 || b > 0
        n = res.length
        if n >= 2 && res[-1] == res[-2]
            write_a = res[-1] == 'b'
        else
            write_a = a >= b
        end
        if write_a
            break if a == 0
            res << 'a'; a -= 1
        else
            break if b == 0
            res << 'b'; b -= 1
        end
    end
    res.join
end
