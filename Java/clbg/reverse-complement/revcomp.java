import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;

public class revcomp {
    private static final byte[] COMPLEMENT = new byte[256];

    static {
        for (int i = 0; i < COMPLEMENT.length; i++) {
            COMPLEMENT[i] = (byte) i;
        }

        String bases = "ACGTUMRWSYKVHDBN";
        String complements = "TGCAAKYWSRMBDHVN";
        for (int i = 0; i < bases.length(); i++) {
            char base = bases.charAt(i);
            byte complement = (byte) complements.charAt(i);
            COMPLEMENT[base] = complement;
            COMPLEMENT[Character.toLowerCase(base)] = complement;
        }
    }

    private static void reverseComplement(byte[] data, int start, int end) {
        int left = start;
        int right = end - 1;

        while (left <= right) {
            byte a = data[left];
            if (a == '\n' || a == '\r') {
                left++;
                continue;
            }

            byte b = data[right];
            if (b == '\n' || b == '\r') {
                right--;
                continue;
            }

            data[left++] = COMPLEMENT[b & 255];
            data[right--] = COMPLEMENT[a & 255];
        }
    }

    public static void main(String[] args) throws Exception {
        int n = Integer.parseInt(args[0]);

        InputStream input = System.in;
        byte[] data = new byte[65536];
        int length = 0;

        while (true) {
            if (length == data.length) {
                int capacity = data.length <= (Integer.MAX_VALUE - 8) / 2
                        ? data.length * 2
                        : Integer.MAX_VALUE - 8;
                if (capacity <= data.length) {
                    throw new OutOfMemoryError("FASTA input is too large");
                }
                data = Arrays.copyOf(data, capacity);
            }

            int count = input.read(data, length, data.length - length);
            if (count < 0) {
                break;
            }
            length += count;
        }

        int sequenceStart = -1;
        int position = 0;
        boolean lineStart = true;

        while (position < length) {
            byte current = data[position];

            if (lineStart && current == '>') {
                if (sequenceStart >= 0) {
                    reverseComplement(data, sequenceStart, position);
                }

                while (position < length
                        && data[position] != '\n'
                        && data[position] != '\r') {
                    position++;
                }
                if (position < length && data[position] == '\r') {
                    position++;
                }
                if (position < length && data[position] == '\n') {
                    position++;
                }

                sequenceStart = position;
                lineStart = true;
            } else {
                lineStart = current == '\n' || current == '\r';
                position++;
            }
        }

        if (sequenceStart >= 0) {
            reverseComplement(data, sequenceStart, length);
        }

        OutputStream output = System.out;
        output.write(data, 0, length);
        output.flush();
    }
}