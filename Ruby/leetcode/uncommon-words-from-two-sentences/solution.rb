def uncommon_from_sentences(s1, s2)
  cnt = Hash.new(0)
  (s1.split + s2.split).each { |w| cnt[w] += 1 }
  cnt.select { |_, c| c == 1 }.keys
end
