class FenwickTree:
    def __init__(self, n):
        self.n = n
        self.bit = [0] * (n + 1)
    def update(self, i, delta):
        while i <= self.n:
            self.bit[i] += delta
            i += i & (-i)
    def query(self, i):
        s = 0
        while i > 0:
            s += self.bit[i]
            i -= i & (-i)
        return s

class Solution:
    def goodTriplets(self, nums1, nums2) -> int:
        n = len(nums1)
        # pos2[v] = index of v in nums2
        pos2 = [0]*n
        for i,v in enumerate(nums2):
            pos2[v] = i
        
        # Transform nums1 into array A where A[i] = pos2[nums1[i]]
        A = [pos2[v] for v in nums1]

        # We want to count triplets (i,j,k) with i<j<k and A[i]<A[j]<A[k].
        # For each j, count how many i<j have A[i]<A[j] and how many k>j have A[k]>A[j].
        # Then sum over j: left_count[j] * right_count[j]

        # left_count[j] = number of elements before j with value < A[j]
        fenw_left = FenwickTree(n)
        left_count = [0]*n
        for j in range(n):
            # A[j] is in [0,n-1], Fenwicks are 1-indexed, so use A[j]+1
            left_count[j] = fenw_left.query(A[j])
            fenw_left.update(A[j]+1, 1)

        # right_count[j] = number of elements after j with value > A[j]
        fenw_right = FenwickTree(n)
        right_count = [0]*n
        for j in range(n-1, -1, -1):
            # number of elements after j with value > A[j] =
            # total elements after j - number of elements after j with value <= A[j]
            # fenw_right.query(n) - fenw_right.query(A[j]+1)
            right_count[j] = fenw_right.query(n) - fenw_right.query(A[j]+1)
            fenw_right.update(A[j]+1, 1)

        # sum over j of left_count[j] * right_count[j]
        ans = 0
        for j in range(n):
            ans += left_count[j] * right_count[j]
        return ans
