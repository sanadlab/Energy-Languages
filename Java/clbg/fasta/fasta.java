import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

public class fasta {
    private static final int IM = 139968;
    private static final int IA = 3877;
    private static final int IC = 29573;
    private static final int WIDTH = 60;

    private static final String ALU =
            "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
          + "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAG"
          + "ACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAA"
          + "TACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCC"
          + "AGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGG"
          + "GAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTC"
          + "CAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

    private static double[] cumulative(double[] probabilities) {
        double sum = 0.0;
        for (int i = 0; i < probabilities.length; i++) {
            sum += probabilities[i];
            probabilities[i] = sum;
        }
        probabilities[probabilities.length - 1] = 1.0;
        return probabilities;
    }

    private static byte select(double value, byte[] symbols, double[] limits) {
        int i = 0;
        while (value >= limits[i]) {
            i++;
        }
        return symbols[i];
    }

    private static int gcd(int a, int b) {
        while (b != 0) {
            int remainder = a % b;
            a = b;
            b = remainder;
        }
        return a;
    }

    private static void writeRepeated(
            OutputStream out, byte[] pattern, int offset, long length)
            throws IOException {
        // Align the block to both the sequence period and the line width.
        int charactersPerBlock =
                (pattern.length / gcd(pattern.length, WIDTH)) * WIDTH;
        byte[] block =
                new byte[charactersPerBlock + charactersPerBlock / WIDTH];

        int source = offset;
        int destination = 0;
        for (int line = 0; line < charactersPerBlock / WIDTH; line++) {
            for (int column = 0; column < WIDTH; column++) {
                block[destination++] = pattern[source++];
                if (source == pattern.length) {
                    source = 0;
                }
            }
            block[destination++] = '\n';
        }

        while (length >= charactersPerBlock) {
            out.write(block);
            length -= charactersPerBlock;
        }

        int remaining = (int) length;
        if (remaining != 0) {
            out.write(block, 0, remaining + remaining / WIDTH);
            if (remaining % WIDTH != 0) {
                out.write('\n');
            }
        }
    }

    public static void main(String[] args) throws IOException {
        int n = Integer.parseInt(args[0]);

        byte[] iubSymbols =
                "acgtBDHKMNRSVWY".getBytes(StandardCharsets.US_ASCII);
        double[] iubLimits = cumulative(new double[] {
                0.27, 0.12, 0.12, 0.27,
                0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
                0.02, 0.02, 0.02, 0.02, 0.02
        });

        byte[] humanSymbols = "acgt".getBytes(StandardCharsets.US_ASCII);
        double[] humanLimits = cumulative(new double[] {
                0.3029549426680,
                0.1979883004921,
                0.1975473066391,
                0.3015094502008
        });

        // This LCG has a full period of IM. Cache one exact period under
        // each distribution, then stream repetitions without changing results.
        byte[] iubPeriod = new byte[IM];
        byte[] humanPeriod = new byte[IM];
        int seed = 42;
        for (int i = 0; i < IM; i++) {
            seed = (seed * IA + IC) % IM;
            double value = (double) seed / IM;
            iubPeriod[i] = select(value, iubSymbols, iubLimits);
            humanPeriod[i] = select(value, humanSymbols, humanLimits);
        }

        OutputStream out = new BufferedOutputStream(System.out, 65536);

        out.write(">ONE Homo sapiens alu\n"
                .getBytes(StandardCharsets.US_ASCII));
        writeRepeated(out, ALU.getBytes(StandardCharsets.US_ASCII), 0, 2L * n);

        out.write(">TWO IUB ambiguity codes\n"
                .getBytes(StandardCharsets.US_ASCII));
        writeRepeated(out, iubPeriod, 0, 3L * n);

        out.write(">THREE Homo sapiens frequency\n"
                .getBytes(StandardCharsets.US_ASCII));
        int humanOffset = (int) ((3L * n) % IM);
        writeRepeated(out, humanPeriod, humanOffset, 5L * n);

        out.flush();
    }
}