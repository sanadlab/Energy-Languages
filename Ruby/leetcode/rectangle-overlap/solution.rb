# @param {Integer[]} rec1
# @param {Integer[]} rec2
# @return {Boolean}
def is_rectangle_overlap(rec1, rec2)
  # Two rectangles do not overlap if one is completely to the left, right,
  # above, or below the other.
  return false if rec1[2] <= rec2[0] # rec1 right <= rec2 left
  return false if rec2[2] <= rec1[0] # rec2 right <= rec1 left
  return false if rec1[3] <= rec2[1] # rec1 top <= rec2 bottom
  return false if rec2[3] <= rec1[1] # rec2 top <= rec1 bottom

  true
end