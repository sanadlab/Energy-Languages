# @param {String} first_word
# @param {String} second_word
# @param {String} target_word
# @return {Boolean}
def is_sum_equal(first_word, second_word, target_word)
  to_num = ->(word) {
    word.chars.map { |c| (c.ord - 'a'.ord).to_s }.join.to_i
  }
  to_num.call(first_word) + to_num.call(second_word) == to_num.call(target_word)
end