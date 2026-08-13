# @param {String} word1
# @param {String} word2
# @return {Boolean}
def close_strings(word1, word2)
    return false if word1.length != word2.length
    f1 = Hash.new(0)
    f2 = Hash.new(0)
    word1.each_char { |c| f1[c] += 1 }
    word2.each_char { |c| f2[c] += 1 }
    return false if f1.keys.sort != f2.keys.sort
    f1.values.sort == f2.values.sort
end
