class Solution:
    def fannkuch(self, n: int) -> str:
        # Initialize
        perm = list(range(n))
        count = list(range(n))
        max_flips = 0
        check = 0
        r = n
        perm1 = list(range(n))

        while True:
            # Copy perm to perm1
            perm1[:] = perm[:]
            flips_count = 0
            first = perm1[0]
            while first != 0:
                # Reverse first+1 elements
                perm1[:first+1] = perm1[first::-1]
                flips_count += 1
                first = perm1[0]

            max_flips = max(max_flips, flips_count)
            if r % 2 == 0:
                check += flips_count
            else:
                check -= flips_count

            # Generate next permutation
            # Find i such that count[i] != 0
            i = 1
            while i < n:
                count[i] -= 1
                if count[i] >= 0:
                    # rotate perm from 0 to i
                    perm[:i+1] = perm[1:i+1] + perm[:1]
                    break
                count[i] = i
                i += 1
            else:
                # No further permutations
                return f"{check}\nPfannkuchen({n}) = {max_flips}"
            r += 1


# Below is a wrapper for LeetCode-style `Solution` class; 
# since standard LeetCode problems don't accept command line,
# we assume the method is called with n directly.

# Example usage:
# sol = Solution()
# print(sol.fannkuch(12))