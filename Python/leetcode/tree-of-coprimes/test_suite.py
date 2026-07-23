# LC-energy test suite (Python) — hardcoded single case.
# Correctness is validated separately by a correctness oracle; this file
# exists ONLY so the perf pipeline (make measure / make mem) has a
# runnable target that calls Solution.
from solution import Solution

def main():
    sol = Solution()
    _ = sol.getCoprimes(nums=[1,2,3,4,5], edges=[[1,2],[3,4]])

if __name__ == '__main__':
    main()
