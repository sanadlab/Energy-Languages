import re
import sys


def main():
    _ = int(sys.argv[1])

    data = sys.stdin.buffer.read()
    original_length = len(data)

    sequence = re.sub(br'>[^\r\n]*(?:\r\n|\n|\r|$)|\r\n|\r|\n', b'', data)
    stripped_length = len(sequence)

    patterns = [
        b'agggtaaa|tttaccct',
        b'[cgt]gggtaaa|tttaccc[acg]',
        b'a[act]ggtaaa|tttacc[agt]t',
        b'ag[act]gtaaa|tttac[agt]ct',
        b'agg[act]taaa|ttta[agt]cct',
        b'aggg[acg]aaa|ttt[cgt]ccct',
        b'agggt[cgt]aa|tt[acg]accct',
        b'agggta[cgt]a|t[acg]taccct',
        b'agggtaa[cgt]|[acg]ttaccct',
    ]

    output = []
    for pattern in patterns:
        count = sum(1 for _ in re.finditer(pattern, sequence))
        output.append(f'{pattern.decode()} {count}')

    substitutions = [
        (br'tHa[Nt]', b'<4>'),
        (br'aND|caN|Ha[DS]|WaS', b'<3>'),
        (br'a[NSt]|BY', b'<2>'),
        (br'<[^>]*>', b'|'),
        (br'\|[^|][^|]*\|', b'-'),
    ]

    encoded = sequence
    for pattern, replacement in substitutions:
        encoded = re.sub(pattern, replacement, encoded)

    output.append('')
    output.append(str(original_length))
    output.append(str(stripped_length))
    output.append(str(len(encoded)))

    sys.stdout.write('\n'.join(output) + '\n')


if __name__ == '__main__':
    main()