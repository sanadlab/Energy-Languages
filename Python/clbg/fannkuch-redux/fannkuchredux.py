import sys

def main():
    if len(sys.argv) < 2:
        return
    n = int(sys.argv[1])

    # Initial permutation: [1, 2, ..., n]
    p = list(range(n))
    q = [0] * n
    s = list(range(n + 1))

    checksum = 0
    max_flips = 0
    sign = 1  # +1 for even permutation index, -1 for odd

    while True:
        # Count flips for current permutation.
        if p[0] != 0:
            q[:] = p
            flips = 0
            first = q[0]
            while first != 0:
                k = first + 1
                i = 0
                j = first
                while i < j:
                    q[i], q[j] = q[j], q[i]
                    i += 1
                    j -= 1
                flips += 1
                first = q[0]
            if flips > max_flips:
                max_flips = flips
        else:
            flips = 0

        checksum += sign * flips

        # Generate next permutation in the specific order.
        i = 1
        while i < n:
            s[i] += 1
            if s[i] <= i:
                break
            s[i] = 0
            i += 1
        else:
            print(checksum)
            print(f"Pfannkuchen({n}) = {max_flips}")
            return

        # Rotate first i+1 elements.
        first = p[0]
        for j in range(i):
            p[j] = p[j + 1]
        p[i] = first

        sign = -sign

if __name__ == "__main__":
    main()