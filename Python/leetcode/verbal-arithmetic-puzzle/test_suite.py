# LC-energy test suite (Python) — hardcoded single case.
# Correctness is validated separately by a correctness oracle; this file
# exists ONLY so the perf pipeline (make measure / make mem) has a
# runnable target that calls Solution.
from solution import Solution

def main():
    sol = Solution()
    _ = sol.isSolvable(words=["a","b","c"], result="abcde")

if __name__ == '__main__':
    main()
