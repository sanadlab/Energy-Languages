import sys

# Reverse-complement mapping for standard DNA and IUPAC ambiguity codes.
# Symmetric pairs are mapped appropriately.
COMP = {
    ord('A'): 'T', ord('a'): 't',
    ord('C'): 'G', ord('c'): 'g',
    ord('G'): 'C', ord('g'): 'c',
    ord('T'): 'A', ord('t'): 'a',
    ord('U'): 'A', ord('u'): 'a',

    ord('M'): 'K', ord('m'): 'k',
    ord('K'): 'M', ord('k'): 'm',
    ord('R'): 'Y', ord('r'): 'y',
    ord('Y'): 'R', ord('y'): 'r',
    ord('S'): 'S', ord('s'): 's',
    ord('W'): 'W', ord('w'): 'w',
    ord('V'): 'B', ord('v'): 'b',
    ord('B'): 'V', ord('b'): 'v',
    ord('H'): 'D', ord('h'): 'd',
    ord('D'): 'H', ord('d'): 'h',
    ord('N'): 'N', ord('n'): 'n',
    ord('-'): '-',
    ord('.'): '.',
}

def main():
    data = sys.stdin.buffer.read().splitlines()
    out = []
    header = None
    seq_parts = []

    def flush():
        if header is None:
            return
        seq = b''.join(seq_parts)
        # Reverse and complement in one pass.
        rc = seq.translate(COMP)[::-1]
        out.append(header)
        # Preserve original line-wrapping by re-wrapping to the same line lengths
        # as in the input sequence lines.
        # We reconstruct wrapping using the original lengths of sequence lines.
        if seq_parts:
            widths = [len(p) for p in seq_parts]
            pos = 0
            for w in widths:
                out.append(rc[pos:pos + w])
                pos += w
        else:
            out.append(b'')
    
    widths = []
    for line in data:
        if line.startswith(b'>'):
            if header is not None:
                seq = b''.join(seq_parts)
                rc = seq.translate(COMP)[::-1]
                out.append(header)
                pos = 0
                for w in widths:
                    out.append(rc[pos:pos + w])
                    pos += w
            header = line
            seq_parts = []
            widths = []
        else:
            seq_parts.append(line)
            widths.append(len(line))

    if header is not None:
        seq = b''.join(seq_parts)
        rc = seq.translate(COMP)[::-1]
        out.append(header)
        pos = 0
        for w in widths:
            out.append(rc[pos:pos + w])
            pos += w

    sys.stdout.buffer.write(b'\n'.join(out))

if __name__ == "__main__":
    main()