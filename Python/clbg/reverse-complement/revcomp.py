import sys


def main():
    _n = int(sys.argv[1])

    table = bytearray(range(256))
    bases = b"ABCDGHKMNRSTVWY"
    complements = b"TVGHCDMKNYSA BWR".replace(b" ", b"")

    for base, complement in zip(bases, complements):
        table[base] = complement
        table[base + 32] = complement

    translation = bytes(table)
    lines = sys.stdin.buffer.read().splitlines()
    output = []

    header = None
    sequence_lines = []

    def emit_record():
        if header is None:
            return

        output.append(header)
        output.append(b"\n")

        if not sequence_lines:
            return

        lengths = [len(line) for line in sequence_lines]
        sequence = b"".join(sequence_lines)
        reversed_complement = sequence[::-1].translate(translation)

        position = 0
        for length in lengths:
            output.append(reversed_complement[position:position + length])
            output.append(b"\n")
            position += length

    for line in lines:
        if line.startswith(b">"):
            emit_record()
            header = line
            sequence_lines = []
        else:
            sequence_lines.append(line)

    emit_record()
    sys.stdout.buffer.write(b"".join(output))


if __name__ == "__main__":
    main()