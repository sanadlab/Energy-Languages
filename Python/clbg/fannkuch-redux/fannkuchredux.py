import os
import sys
from multiprocessing import Pool


def evaluate_block(args):
    n, start, size, factorials = args

    permutation = list(range(n))
    counts = list(range(n))
    index = start

    # Decode the starting index in the benchmark's rotation-based order.
    for i in range(n - 1, 0, -1):
        rotation, index = divmod(index, factorials[i])
        counts[i] = i - rotation
        if rotation:
            permutation[:i + 1] = (
                permutation[rotation:i + 1] + permutation[:rotation]
            )

    checksum = 0
    maximum = 0
    pairs_left = size // 2

    while pairs_left:
        # Even-indexed permutation.
        first = permutation[0]
        if first:
            flips = 1
            following = permutation[first]
            if following:
                work = permutation[:]
                while following:
                    # The first element is held in 'first', so neither
                    # endpoint needs to participate in the slice reversal.
                    work[first] = first
                    if first > 2:
                        work[1:first] = work[first - 1:0:-1]
                    first = following
                    following = work[first]
                    flips += 1

            checksum += flips
            if flips > maximum:
                maximum = flips

        permutation[0], permutation[1] = permutation[1], permutation[0]

        # Odd-indexed permutation.
        first = permutation[0]
        if first:
            flips = 1
            following = permutation[first]
            if following:
                work = permutation[:]
                while following:
                    work[first] = first
                    if first > 2:
                        work[1:first] = work[first - 1:0:-1]
                    first = following
                    following = work[first]
                    flips += 1

            checksum -= flips
            if flips > maximum:
                maximum = flips

        pairs_left -= 1
        if not pairs_left:
            break

        # Combine the first two rotation levels into a single swap.
        permutation[1], permutation[2] = permutation[2], permutation[1]
        i = 2
        while counts[i] == 0:
            counts[i] = i
            i += 1
            permutation[:i + 1] = (
                permutation[1:i + 1] + permutation[:1]
            )
        counts[i] -= 1

    return checksum, maximum


def main():
    n = int(sys.argv[1])

    if n <= 1:
        print(f"0\nPfannkuchen({n}) = 0")
        return

    factorials = [1] * (n + 1)
    for i in range(2, n + 1):
        factorials[i] = factorials[i - 1] * i

    total = factorials[n]
    block_size = factorials[min(n, 8)]
    block_count = total // block_size

    cpu_count = os.cpu_count() or 1
    if hasattr(os, "sched_getaffinity"):
        try:
            cpu_count = min(cpu_count, len(os.sched_getaffinity(0)))
        except OSError:
            pass
    workers = min(cpu_count, block_count, 32)

    tasks = (
        (n, start, block_size, factorials)
        for start in range(0, total, block_size)
    )

    checksum = 0
    maximum = 0

    if workers == 1:
        for partial_checksum, partial_maximum in map(evaluate_block, tasks):
            checksum += partial_checksum
            if partial_maximum > maximum:
                maximum = partial_maximum
    else:
        with Pool(workers) as pool:
            for partial_checksum, partial_maximum in pool.imap_unordered(
                evaluate_block, tasks, chunksize=1
            ):
                checksum += partial_checksum
                if partial_maximum > maximum:
                    maximum = partial_maximum

    print(f"{checksum}\nPfannkuchen({n}) = {maximum}")


if __name__ == "__main__":
    main()