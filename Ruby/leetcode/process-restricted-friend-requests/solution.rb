# @param {Integer} n
# @param {Integer[][]} restrictions
# @param {Integer[][]} requests
# @return {Boolean[]}
def friend_requests(n, restrictions, requests)
  parent = (0...n).to_a
  find = lambda do |x|
    while parent[x] != x
      parent[x] = parent[parent[x]]
      x = parent[x]
    end
    x
  end
  res = []
  requests.each do |req|
    u = req[0]
    v = req[1]
    pu = find.call(u)
    pv = find.call(v)
    if pu == pv
      res << true
      next
    end
    ok = true
    restrictions.each do |r|
      px = find.call(r[0])
      py = find.call(r[1])
      if (px == pu && py == pv) || (px == pv && py == pu)
        ok = false
        break
      end
    end
    if ok
      parent[pu] = pv
      res << true
    else
      res << false
    end
  end
  res
end
