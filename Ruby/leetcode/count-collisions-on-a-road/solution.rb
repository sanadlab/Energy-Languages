# @param {String} directions
# @return {Integer}
def count_collisions(directions)
  # Remove all leading 'L's (they move left and won't collide)
  left = 0
  while left < directions.size && directions[left] == 'L'
    left += 1
  end

  # Remove all trailing 'R's (they move right and won't collide)
  right = directions.size - 1
  while right >= 0 && directions[right] == 'R'
    right -= 1
  end

  # Count collisions in the middle segment
  collisions = 0
  (left..right).each do |i|
    collisions += 1 if directions[i] != 'S'
  end

  collisions
end