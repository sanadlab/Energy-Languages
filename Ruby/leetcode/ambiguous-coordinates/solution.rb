# @param {String} s
# @return {String[]}
def ambiguous_coordinates(s)
    digits = s[1...-1]
    n = digits.length
    make = lambda do |d|
        out = []
        m = d.length
        if m == 1
            out << d
            return out
        end
        out << d if d[0] != '0'
        (1...m).each do |i|
            l = d[0...i]
            r = d[i..-1]
            if (l == '0' || l[0] != '0') && r[-1] != '0'
                out << (l + '.' + r)
            end
        end
        out
    end
    res = []
    (1...n).each do |i|
        left = make.call(digits[0...i])
        right = make.call(digits[i..-1])
        left.each do |a|
            right.each do |b|
                res << "(#{a}, #{b})"
            end
        end
    end
    res
end
