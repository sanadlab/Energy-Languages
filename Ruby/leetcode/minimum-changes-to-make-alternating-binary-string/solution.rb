# @param {String} s
# @return {Integer}
def min_operations(s)
  cnt = 0
  n = s.length
  (0...n).each do |i|
    expected = i.even? ? '0' : '1'
    cnt += 1 if s[i] != expected
  end
  [cnt, n - cnt].min
end
