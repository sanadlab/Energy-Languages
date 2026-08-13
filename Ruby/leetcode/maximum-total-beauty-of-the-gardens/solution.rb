# @param {Integer[]} flowers
# @param {Integer} new_flowers
# @param {Integer} target
# @param {Integer} full
# @param {Integer} partial
# @return {Integer}
def maximum_beauty(flowers, new_flowers, target, full, partial)
  n = flowers.length
  return 0 if n == 0
  fl = flowers.map { |f| [f, target].min }.sort
  pre = Array.new(n + 1, 0)
  (0...n).each { |i| pre[i + 1] = pre[i] + fl[i] }
  return full * n if fl[0] == target
  lower_bound = lambda do |hi_idx, v|
    lo = 0
    hi = hi_idx
    while lo < hi
      mid = (lo + hi) / 2
      if fl[mid] < v
        lo = mid + 1
      else
        hi = mid
      end
    end
    lo
  end
  ans = 0
  n.downto(0) do |i|
    cost_complete = target * (n - i) - (pre[n] - pre[i])
    next if cost_complete > new_flowers
    rem = new_flowers - cost_complete
    if i == 0
      ans = [ans, full * (n - i)].max
      next
    end
    lo = 0
    hi = target - 1
    best_min = 0
    while lo <= hi
      v = (lo + hi) / 2
      k = lower_bound.call(i, v)
      cost = v * k - pre[k]
      if cost <= rem
        best_min = v
        lo = v + 1
      else
        hi = v - 1
      end
    end
    ans = [ans, full * (n - i) + best_min * partial].max
  end
  ans
end
