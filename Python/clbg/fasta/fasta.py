import sys

def main():
    N = int(sys.argv[1])

    out = sys.stdout.write

    alu = (
        "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
        "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
        "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
        "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
        "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"
    )
    alu_len = len(alu)

    def write_wrapped_repeat(length):
        idx = 0
        remaining = length
        while remaining > 0:
            line_len = 60 if remaining >= 60 else remaining
            if idx + line_len <= alu_len:
                out(alu[idx:idx + line_len] + "\n")
                idx += line_len
                if idx == alu_len:
                    idx = 0
            else:
                part1 = alu[idx:]
                part2_len = line_len - len(part1)
                out(part1 + alu[:part2_len] + "\n")
                idx = part2_len
            remaining -= line_len

    IM = 139968
    IA = 3877
    IC = 29573
    seed = 42

    def make_table(items):
        # items: list of (char, probability)
        table = []
        acc = 0.0
        for ch, p in items:
            acc += p
            table.append((acc, ch))
        return table

    iub = make_table([
        ('a', 0.27), ('c', 0.12), ('g', 0.12), ('t', 0.27),
        ('B', 0.02), ('D', 0.02), ('H', 0.02), ('K', 0.02),
        ('M', 0.02), ('N', 0.02), ('R', 0.02), ('S', 0.02),
        ('V', 0.02), ('W', 0.02), ('Y', 0.02),
    ])

    homo = make_table([
        ('a', 0.3029549426680),
        ('c', 0.1979883004921),
        ('g', 0.1975473066391),
        ('t', 0.3015094502008),
    ])

    def write_random(length, table):
        nonlocal seed
        remaining = length
        vals = [x[0] * IM for x in table]
        chars = [x[1] for x in table]
        tlen = len(table)

        while remaining > 0:
            line_len = 60 if remaining >= 60 else remaining
            line_chars = []
            for _ in range(line_len):
                seed = (seed * IA + IC) % IM
                r = seed
                # binary search would be fine, but tiny tables => linear is fastest here
                for i in range(tlen):
                    if r < vals[i]:
                        line_chars.append(chars[i])
                        break
            out(''.join(line_chars) + "\n")
            remaining -= line_len

    out(">ONE Homo sapiens alu\n")
    write_wrapped_repeat(N * 2)

    out(">TWO IUB ambiguity codes\n")
    write_random(N * 3, iub)

    out(">THREE Homo sapiens frequency\n")
    write_random(N * 5, homo)

if __name__ == "__main__":
    main()