# @param {String} s
# @param {Integer} k
# @return {String}
def license_key_formatting(s, k)
  # Remove all dashes and convert to uppercase
  chars = s.delete('-').upcase.chars
  # Result array for groups
  result = []
  
  # Process from the end, taking k characters at a time
  i = chars.size
  while i > 0
    start = [i - k, 0].max
    result.unshift(chars[start...i].join)
    i = start
  end
  
  # Join groups with dashes
  result.join('-')
end