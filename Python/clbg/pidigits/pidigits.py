import sys
from math import isqrt

def main():
    N = int(sys.argv[1])

    # Unbounded spigot algorithm (Rabinowitz and Wagon)
    q, r, t, k, n, l = 1, 0, 1, 1, 3, 3
    out = []
    line = []

    for i in range(N):
        while 4 * q + r - t >= n * t:
            q, r, t, k, n, l = (
                10 * q,
                10 * (r - n * t),
                t,
                k,
                (10 * (3 * q + r)) // t - 10 * n,
                l,
            )

        line.append(str(n))
        if len(line) == 10:
            out.append("".join(line) + "\t:" + str(i + 1))
            line.clear()

        q, r, t, k, n, l = (
            q * k,
            (2 * q + r) * l,
            t * l,
            k + 1,
            (q * (7 * k + 2) + r * l) // (t * l),
            l + 2,
        )

    if line:
        out.append("".join(line) + "\t:" + str(N))

    sys.stdout.write("\n".join(out))

if __name__ == "__main__":
    main()