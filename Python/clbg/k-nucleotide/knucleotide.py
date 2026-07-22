import sys

class Solution:
    def solve(self):
        # Read stdin and parse the THREE section of the fasta input
        # The input is fasta format:
        # >THREE
        # sequence lines ...
        # possibly other sections but problem states only THREE section input

        lines = sys.stdin.read().splitlines()
        # Find the start of the THREE section
        seq_lines = []
        in_three = False
        for line in lines:
            if line.startswith('>'):
                in_three = (line[1:].strip() == 'THREE')
                continue
            if in_three:
                seq_lines.append(line)

        # Combine and normalize sequence to upper case
        seq = "".join(seq_lines).upper()

        # Count 1-mers frequencies
        freq_1 = {}
        for c in seq:
            freq_1[c] = freq_1.get(c, 0) + 1

        # Count 2-mers frequencies
        freq_2 = {}
        for i in range(len(seq) - 1):
            k2 = seq[i:i+2]
            freq_2[k2] = freq_2.get(k2, 0) + 1

        # Report 1-mer frequencies sorted descending count, then lex
        for k, v in sorted(freq_1.items(), key=lambda x: (-x[1], x[0])):
            print(f"{k} {v}")

        # Blank line between sections
        print()

        # Report 2-mer frequencies sorted descending count, then lex
        for k, v in sorted(freq_2.items(), key=lambda x: (-x[1], x[0])):
            print(f"{k} {v}")

        # Blank line between sections
        print()

        # Count occurrences of the specific fragments:
        fragments = [
            "GGT",
            "GGTA",
            "GGTATT",
            "GGTATTTTAATT",
            "GGTATTTTAATTTATAGT",
        ]
        for fragment in fragments:
            count = 0
            start = 0
            flen = len(fragment)
            # count occurrences including overlapping
            while True:
                pos = seq.find(fragment, start)
                if pos == -1:
                    break
                count += 1
                start = pos + 1
            print(f"{count}\t{fragment}")

if __name__ == "__main__":
    Solution().solve()