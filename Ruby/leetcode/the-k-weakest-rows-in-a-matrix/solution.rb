# @param {Integer[][]} mat
# @param {Integer} k
# @return {Integer[]}
def k_weakest_rows(mat, k)
  # Count soldiers in each row and keep track of the index
  counts = mat.each_with_index.map { |row, i| [row.count(1), i] }
  # Sort by soldier count, then by index
  counts.sort_by! { |count, i| [count, i] }
  # Extract the first k indices
  counts.first(k).map { |_, i| i }
end