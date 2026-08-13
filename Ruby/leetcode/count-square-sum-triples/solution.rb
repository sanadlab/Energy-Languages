# @param {Integer} n
# @return {Integer}
def count_triples(n)
  count = 0
  (1..n).each do |a|
    (1..n).each do |b|
      c2 = a * a + b * b
      c = Integer.sqrt(c2)
      count += 1 if c >= 1 && c <= n && c * c == c2
    end
  end
  count
end
