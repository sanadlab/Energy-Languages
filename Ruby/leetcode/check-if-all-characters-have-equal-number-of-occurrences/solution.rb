# @param {String} s
# @return {Boolean}
def are_occurrences_equal(s)
  freq = Hash.new(0)
  s.each_char { |ch| freq[ch] += 1 }
  freq.values.uniq.size == 1
end