# @param {Integer[]} nums1
# @param {Integer[]} nums2
# @return {Integer}
def num_triplets(nums1, nums2)
  helper = lambda do |a, b|
    cnt = 0
    a.each do |x|
      t = x * x
      seen = Hash.new(0)
      b.each do |y|
        if t % y == 0
          need = t / y
          cnt += seen[need]
        end
        seen[y] += 1
      end
    end
    cnt
  end
  helper.call(nums1, nums2) + helper.call(nums2, nums1)
end
