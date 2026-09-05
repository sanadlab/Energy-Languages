import sys
from collections import Counter


def main():
    _n = int(sys.argv[1])

    data = sys.stdin.buffer.read()
    header = data.find(b">THREE")
    if header < 0:
        sequence = b""
    else:
        line_end = data.find(b"\n", header)
        if line_end < 0:
            sequence = b""
        else:
            section_end = data.find(b"\n>", line_end)
            if section_end < 0:
                section_end = len(data)
            sequence = data[line_end + 1:section_end]
            sequence = sequence.translate(None, b" \t\r\n\v\f").upper()

    output = []

    one_counts = Counter(sequence)
    one_total = len(sequence)
    for nucleotide, count in sorted(
        one_counts.items(), key=lambda item: item[1], reverse=True
    ):
        percentage = 100.0 * count / one_total if one_total else 0.0
        output.append(f"{chr(nucleotide)} {percentage:.3f}")

    output.append("")

    pair_counts = [0] * 65536
    if len(sequence) >= 2:
        previous = sequence[0]
        for current in sequence[1:]:
            pair_counts[(previous << 8) | current] += 1
            previous = current

    two_total = len(sequence) - 1
    pairs = [(index, count) for index, count in enumerate(pair_counts) if count]
    pairs.sort(key=lambda item: item[1], reverse=True)

    for index, count in pairs:
        pair = chr(index >> 8) + chr(index & 255)
        percentage = 100.0 * count / two_total if two_total > 0 else 0.0
        output.append(f"{pair} {percentage:.3f}")

    output.append("")

    fragments = (
        b"GGT",
        b"GGTA",
        b"GGTATT",
        b"GGTATTTTAATT",
        b"GGTATTTTAATTTATAGT",
    )
    for fragment in fragments:
        output.append(f"{sequence.count(fragment)}\t{fragment.decode('ascii')}")

    sys.stdout.write("\n".join(output) + "\n")


if __name__ == "__main__":
    main()