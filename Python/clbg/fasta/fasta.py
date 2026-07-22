class Solution:
    def fasta(self, N: int) -> str:
        IM = 139968
        IA = 3877
        IC = 29573

        # PRNG generator setup
        rng_last = 42

        def prng():
            nonlocal rng_last
            rng_last = (rng_last * IA + IC) % IM
            return rng_last / IM

        def make_repeat_sequence(seq, length):
            # repeat seq until length, then cut
            full = (seq * (length // len(seq) + 1))[:length]
            return full

        def make_weighted_sequence(table, length):
            # table is list of (symbol, weight) pairs
            total_weight = sum(w for c, w in table)
            cum_weights = []
            s = 0.0
            for c, w in table:
                s += w
                cum_weights.append((c, s / total_weight))  # cumulative probability

            seq_chars = []
            for _ in range(length):
                r = prng()
                for c, threshold in cum_weights:
                    if r < threshold:
                        seq_chars.append(c)
                        break
            return "".join(seq_chars)

        def wrap_seq(seq):
            lines = []
            for i in range(0, len(seq), 60):
                lines.append(seq[i:i + 60])
            return "\n".join(lines)

        # Sequence 1: ALU repeat 2N
        alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" \
              "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" \
              "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" \
              "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" \
              "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" \
              "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" \
              "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"
        seq1_length = 2 * N
        seq1 = make_repeat_sequence(alu, seq1_length)

        # Sequence 2: IUB ambiguity codes (3N)
        iub = [
            ('a', 0.27),
            ('c', 0.12),
            ('g', 0.12),
            ('t', 0.27),
            ('B', 0.02),
            ('D', 0.02),
            ('H', 0.02),
            ('K', 0.02),
            ('M', 0.02),
            ('N', 0.02),
            ('R', 0.02),
            ('S', 0.02),
            ('V', 0.02),
            ('W', 0.02),
            ('Y', 0.02),
        ]
        seq2_length = 3 * N
        seq2 = make_weighted_sequence(iub, seq2_length)

        # Sequence 3: Homo sapiens frequency (5N)
        homo_sapiens = [
            ('a', 0.3029549426680),
            ('c', 0.1979883004921),
            ('g', 0.1975473066391),
            ('t', 0.3015094502008),
        ]
        seq3_length = 5 * N
        seq3 = make_weighted_sequence(homo_sapiens, seq3_length)

        out = []
        out.append(">ONE Homo sapiens alu")
        out.append(wrap_seq(seq1))
        out.append(">TWO IUB ambiguity codes")
        out.append(wrap_seq(seq2))
        out.append(">THREE Homo sapiens frequency")
        out.append(wrap_seq(seq3))

        return "\n".join(out)