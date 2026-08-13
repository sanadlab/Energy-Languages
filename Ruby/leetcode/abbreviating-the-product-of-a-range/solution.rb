# @param {Integer} left
# @param {Integer} right
# @return {String}
def abbreviate_product(left, right)
  p = 1
  (left..right).each { |i| p *= i }
  c = 0
  while p % 10 == 0
    p /= 10
    c += 1
  end
  s = p.to_s
  if s.length <= 10
    "#{s}e#{c}"
  else
    "#{s[0, 5]}...#{s[-5, 5]}e#{c}"
  end
end
