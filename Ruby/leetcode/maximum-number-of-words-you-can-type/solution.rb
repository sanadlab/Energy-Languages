# @param {String} text
# @param {String} broken_letters
# @return {Integer}
def can_be_typed_words(text, broken_letters)
  count = 0
  text.split(' ').each do |word|
    count += 1 if word.chars.none? { |c| broken_letters.include?(c) }
  end
  count
end
