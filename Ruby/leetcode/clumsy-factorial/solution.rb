# @param {Integer} n
# @return {Integer}
def clumsy(n)
  stack = []
  stack.push(n)
  n -= 1
  i = 0
  while n > 0
    case i % 4
    when 0
      stack.push(stack.pop * n)
    when 1
      top = stack.pop
      # floor division
      if top < 0
        stack.push(-((-top) / n))
      else
        stack.push(top / n)
      end
    when 2
      stack.push(n)
    when 3
      stack.push(-n)
    end
    n -= 1
    i += 1
  end
  stack.sum
end