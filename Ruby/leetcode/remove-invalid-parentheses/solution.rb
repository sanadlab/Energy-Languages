# @param {String} s
# @return {String[]}
def remove_invalid_parentheses(s)
    valid = lambda do |st|
        cnt = 0
        st.each_char do |ch|
            if ch == '('
                cnt += 1
            elsif ch == ')'
                cnt -= 1
                return false if cnt < 0
            end
        end
        cnt == 0
    end
    level = [s]
    until level.empty?
        valids = level.select { |st| valid.call(st) }
        return valids unless valids.empty?
        nxt = {}
        level.each do |st|
            (0...st.length).each do |i|
                if st[i] == '(' || st[i] == ')'
                    nxt[st[0...i] + st[(i + 1)..-1]] = true
                end
            end
        end
        level = nxt.keys
    end
    [""]
end
