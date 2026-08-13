# @param {Integer} n
# @return {Integer}
def count_vowel_permutation(n)
  mod = 1_000_000_007

  a = e = i = o = u = 1

  (n - 1).times do
    na = (e + i + u) % mod
    ne = (a + i) % mod
    ni = (e + o) % mod
    no = i % mod
    nu = (i + o) % mod

    a, e, i, o, u = na, ne, ni, no, nu
  end

  (a + e + i + o + u) % mod
end