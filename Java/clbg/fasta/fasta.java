import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

class fasta {
    private static final int LINE_LENGTH = 60;

    private static final int IM = 139968;
    private static final int IA = 3877;
    private static final int IC = 29573;

    private static int randomState = 42;

    private static final byte[] ALU = (
        "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATA" +
        "CAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGC" +
        "TACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGG" +
        "CGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCC" +
        "TGGGCGACAGAGCGAGACTCCGTCTCAAAAA"
    ).getBytes(StandardCharsets.US_ASCII);

    private static final byte[] IUB_SYMBOLS = {
        'a', 'c', 'g', 't', 'B', 'D', 'H', 'K',
        'M', 'N', 'R', 'S', 'V', 'W', 'Y'
    };

    private static final double[] IUB_PROBABILITIES = {
        0.27, 0.12, 0.12, 0.27,
        0.02, 0.02, 0.02, 0.02, 0.02, 0.02,
        0.02, 0.02, 0.02, 0.02, 0.02
    };

    private static final byte[] HOMO_SYMBOLS = {
        'a', 'c', 'g', 't'
    };

    private static final double[] HOMO_PROBABILITIES = {
        0.3029549426680,
        0.1979883004921,
        0.1975473066391,
        0.3015094502008
    };

    public static void main(String[] args) throws Exception {
        int n = Integer.parseInt(args[0]);

        FastOutput out = new FastOutput();

        out.writeAscii(">ONE Homo sapiens alu\n");
        writeRepeated(out, ALU, 2L * n);

        out.writeAscii(">TWO IUB ambiguity codes\n");
        writeRandom(out, createLookup(IUB_SYMBOLS, IUB_PROBABILITIES), 3L * n);

        out.writeAscii(">THREE Homo sapiens frequency\n");
        writeRandom(out, createLookup(HOMO_SYMBOLS, HOMO_PROBABILITIES), 5L * n);

        out.flush();
    }

    private static byte[] createLookup(byte[] symbols, double[] probabilities) {
        double[] cumulative = new double[probabilities.length];
        double total = 0.0;

        for (int i = 0; i < probabilities.length; i++) {
            total += probabilities[i];
            cumulative[i] = total;
        }

        byte[] lookup = new byte[IM];

        for (int value = 0; value < IM; value++) {
            double random = (double) value / IM;
            int index = 0;

            while (index < cumulative.length - 1
                    && !(random < cumulative[index])) {
                index++;
            }

            lookup[value] = symbols[index];
        }

        return lookup;
    }

    private static void writeRepeated(FastOutput out, byte[] sequence, long length)
            throws IOException {
        byte[] line = new byte[LINE_LENGTH + 1];
        line[LINE_LENGTH] = '\n';

        int position = 0;
        long remaining = length;

        while (remaining > 0) {
            int count = (int) Math.min(LINE_LENGTH, remaining);

            for (int i = 0; i < count; i++) {
                line[i] = sequence[position++];
                if (position == sequence.length) {
                    position = 0;
                }
            }

            line[count] = '\n';
            out.write(line, 0, count + 1);
            remaining -= count;
        }
    }

    private static void writeRandom(FastOutput out, byte[] lookup, long length)
            throws IOException {
        byte[] line = new byte[LINE_LENGTH + 1];
        line[LINE_LENGTH] = '\n';

        int state = randomState;
        long remaining = length;

        while (remaining > 0) {
            int count = (int) Math.min(LINE_LENGTH, remaining);

            for (int i = 0; i < count; i++) {
                state = (state * IA + IC) % IM;
                line[i] = lookup[state];
            }

            line[count] = '\n';
            out.write(line, 0, count + 1);
            remaining -= count;
        }

        randomState = state;
    }

    private static final class FastOutput {
        private static final int BUFFER_SIZE = 1 << 16;

        private final FileOutputStream stream =
            new FileOutputStream(FileDescriptor.out);
        private final byte[] buffer = new byte[BUFFER_SIZE];
        private int position;

        void writeAscii(String text) throws IOException {
            byte[] bytes = text.getBytes(StandardCharsets.US_ASCII);
            write(bytes, 0, bytes.length);
        }

        void write(byte[] source, int offset, int length) throws IOException {
            while (length > 0) {
                int available = buffer.length - position;

                if (available == 0) {
                    flushBuffer();
                    available = buffer.length;
                }

                int count = Math.min(available, length);
                System.arraycopy(source, offset, buffer, position, count);

                position += count;
                offset += count;
                length -= count;
            }
        }

        void flush() throws IOException {
            flushBuffer();
            stream.flush();
        }

        private void flushBuffer() throws IOException {
            if (position > 0) {
                stream.write(buffer, 0, position);
                position = 0;
            }
        }
    }
}