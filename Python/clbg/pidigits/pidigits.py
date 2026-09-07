import sys


def main():
    target = int(sys.argv[1])

    q, r, t = 1, 0, 1
    k, digit, l = 1, 3, 3

    produced = 0
    group = []
    output = []

    while produced < target:
        digit_t = digit * t

        if (q << 2) + r - t < digit_t:
            group.append(chr(48 + digit))
            produced += 1

            old_q, old_r = q, r
            q = old_q * 10
            r = (old_r - digit_t) * 10
            digit = (10 * (3 * old_q + old_r)) // t - digit * 10

            if len(group) == 10 or produced == target:
                digits = ''.join(group)
                output.append(digits.ljust(10) + "\t:" + str(produced))
                group.clear()
        else:
            qk = q * k
            rl = r * l
            tl = t * l

            digit = (7 * qk + rl + 2) // tl
            r = rl + (qk << 2) + (q << 1)
            q = qk
            t = tl
            k += 1
            l += 2

    sys.stdout.write('\n'.join(output) + '\n')


if __name__ == "__main__":
    main()