class Solution
  VOWELS = {
    'a' => true,
    'e' => true,
    'i' => true,
    'o' => true,
    'u' => true
  }.freeze

  def count_vowel_substrings(word)
    chars = word.chars
    n = chars.length
    count = 0

    (0...n).each do |i|
      seen = {}

      (i...n).each do |j|
        c = chars[j]
        break unless VOWELS[c]

        seen[c] = true
        count += 1 if seen.length == 5
      end
    end

    count
  end
end

def count_vowel_substrings(word)
  Solution.new.count_vowel_substrings(word)
end