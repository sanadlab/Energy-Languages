# @param {String} begin_word
# @param {String} end_word
# @param {String[]} word_list
# @return {Integer}
def ladder_length(begin_word, end_word, word_list)
  return 0 unless word_list.include?(end_word)

  word_len = begin_word.length
  all_combo_dict = Hash.new { |h, k| h[k] = [] }

  word_list.each do |word|
    (0...word_len).each do |i|
      pattern = word[0...i] + '*' + word[i+1..-1]
      all_combo_dict[pattern] << word
    end
  end

  queue = [[begin_word, 1]]
  visited = {begin_word => true}

  while !queue.empty?
    current_word, level = queue.shift

    (0...word_len).each do |i|
      pattern = current_word[0...i] + '*' + current_word[i+1..-1]

      all_combo_dict[pattern].each do |adj_word|
        return level + 1 if adj_word == end_word

        unless visited[adj_word]
          visited[adj_word] = true
          queue << [adj_word, level + 1]
        end
      end
      all_combo_dict[pattern] = []
    end
  end

  0
end