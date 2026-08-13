# @param {Integer} n
# @param {Integer[]} batteries
# @return {Integer}
def max_run_time(n, batteries)
  sum = batteries.sum
  lo = 0
  hi = sum / n
  while lo < hi
    mid = (lo + hi + 1) / 2
    avail = 0
    batteries.each { |b| avail += b < mid ? b : mid }
    if avail >= n * mid
      lo = mid
    else
      hi = mid - 1
    end
  end
  lo
end
