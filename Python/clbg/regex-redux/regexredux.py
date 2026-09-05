import sys
import re

def main():
    # Read entire FASTA input
    data = sys.stdin.buffer.read().decode()

    # Preserve original length exactly as input characters count
    original_length = len(data)

    # Strip FASTA headers and all whitespace/newlines
    seq = re.sub(r'>[^\n]*\n|\s+', '', data)
    stripped_length = len(seq)

    # Patterns from the regex-redux benchmark
    patterns = [
        r'agggtaaa|tttaccct',
        r'[cgt]gggtaaa|tttaccc[acg]',
        r'a[act]ggtaaa|tttacc[agt]t',
        r'ag[act]gtaaa|tttac[agt]ct',
        r'agg[act]taaa|ttta[agt]cct',
        r'aggg[acg]aaa|ttt[cgt]ccct',
        r'agggt[cgt]aa|tt[a-c]accct',
        r'agggta[cgt]a|t[acg]taccct',
    ]

    out = []
    for pat in patterns:
        out.append(f"{pat} {len(re.findall(pat, seq))}")

    # IUPAC substitutions
    substitutions = [
        (r'B', '(c|g|t)'),
        (r'D', '(a|g|t)'),
        (r'H', '(a|c|t)'),
        (r'K', '(g|t)'),
        (r'M', '(a|c)'),
        (r'N', '(a|c|g|t)'),
        (r'R', '(a|g)'),
        (r'S', '(c|g)'),
        (r'V', '(a|c|g)'),
        (r'W', '(a|t)'),
        (r'Y', '(c|t)'),
    ]

    for pat, repl in substitutions:
        seq = re.sub(pat, repl, seq)

    post_length = len(seq)

    out.append(str(original_length))
    out.append(str(stripped_length))
    out.append(str(post_length))

    sys.stdout.write("\n".join(out))

if __name__ == "__main__":
    main()