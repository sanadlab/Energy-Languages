# @param {String[]} queries
# @param {String[]} words
# @return {Integer[]}
def num_smaller_by_frequency(queries, words)
  f = lambda do |s|
    mn = 'z'
    cnt = 0
    s.each_char do |c|
      if c < mn
        mn = c
        cnt = 1
      elsif c == mn
        cnt += 1
      end
    end
    cnt
  end
  word_freqs = words.map { |w| f.call(w) }
  queries.map do |q|
    fq = f.call(q)
    word_freqs.count { |v| v > fq }
  end
end
