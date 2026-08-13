# Reference Ruby solution for finding-mk-average.
#
# Design: a sliding window of the last m added values (a ring buffer) plus two
# Fenwick / BIT trees indexed by the value domain [0, 1e5]:
#   - @cnt: count of elements at each value
#   - @sm : sum of elements at each value (value * count)
# addElement is O(log V); calculateMKAverage removes the k smallest and k largest
# via prefix "sum of the r smallest" queries, so it is O(log V) too. This avoids
# the previous O(m log m) per-call full-window sort.
class MKAverage
  MAXV = 100_000

  def initialize(m, k)
    @m = m
    @k = k
    @div = m - 2 * k
    @n = MAXV + 1            # 1-indexed value domain: index = value + 1, range 1..@n
    @cnt = Array.new(@n + 1, 0)
    @sm  = Array.new(@n + 1, 0)
    @buf = Array.new(m, 0)   # ring buffer of the last m values
    @head = 0
    @size = 0
    @total = 0
    @log = 1                 # highest power of two <= @n, for the Fenwick walk
    @log <<= 1 while (@log << 1) <= @n
  end

  def add_element(num)
    if @size == @m
      old = @buf[@head]
      bump(old, -1)
      @total -= old
      @buf[@head] = num
      @head = (@head + 1) % @m
    else
      @buf[(@head + @size) % @m] = num
      @size += 1
    end
    bump(num, 1)
    @total += num
    nil
  end

  def calculate_mk_average
    return -1 if @size < @m
    # middle sum = sum of the (m-k) smallest minus sum of the k smallest,
    # which drops both the k smallest and (by symmetry) the k largest values.
    mid = sum_smallest(@m - @k) - sum_smallest(@k)
    mid / @div
  end

  private

  # add `delta` copies of value `val` to both Fenwick trees.
  def bump(val, delta)
    i = val + 1
    ds = delta * val
    while i <= @n
      @cnt[i] += delta
      @sm[i]  += ds
      i += i & -i
    end
  end

  # sum of the r smallest elements currently in the window.
  def sum_smallest(r)
    return 0 if r <= 0
    pos = 0
    remaining = r
    accsum = 0
    step = @log
    while step > 0
      nxt = pos + step
      if nxt <= @n && @cnt[nxt] < remaining
        pos = nxt
        remaining -= @cnt[nxt]
        accsum += @sm[nxt]
      end
      step >>= 1
    end
    # boundary value = pos (index pos+1 maps to value pos); `remaining` copies
    # of it complete the r smallest.
    accsum + remaining * pos
  end
end
