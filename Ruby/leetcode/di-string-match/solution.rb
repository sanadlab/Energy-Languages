class Solution
  def di_string_match(s)
    n = s.length
    low = 0
    high = n
    perm = Array.new(n + 1)
    
    (0...n).each do |i|
      if s[i] == 'I'
        perm[i] = low
        low += 1
      else
        perm[i] = high
        high -= 1
      end
    end
    perm[n] = low
    perm
  end
end