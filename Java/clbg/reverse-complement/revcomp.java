import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Arrays;

class revcomp {
    private static final byte[] COMPLEMENT = new byte[256];

    static {
        for (int i = 0; i < COMPLEMENT.length; i++) {
            COMPLEMENT[i] = (byte) i;
        }

        String bases = "ACBDGHKMNSRUTWVYacbdghkmnsrutwvy";
        String complements = "TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR";

        for (int i = 0; i < bases.length(); i++) {
            COMPLEMENT[bases.charAt(i)] = (byte) complements.charAt(i);
        }
    }

    public static void main(String[] args) throws IOException {
        int n = Integer.parseInt(args[0]);

        byte[] data = readAll(System.in);
        int length = data.length;
        int sequenceStart = -1;

        for (int i = 0; i < length; ) {
            boolean lineStart = i == 0 || data[i - 1] == '\n' || data[i - 1] == '\r';

            if (lineStart && data[i] == '>') {
                if (sequenceStart >= 0) {
                    reverseComplement(data, sequenceStart, i);
                }

                while (i < length && data[i] != '\n' && data[i] != '\r') {
                    i++;
                }

                if (i < length && data[i] == '\r') {
                    i++;
                    if (i < length && data[i] == '\n') {
                        i++;
                    }
                } else if (i < length) {
                    i++;
                }

                sequenceStart = i;
            } else {
                i++;
            }
        }

        if (sequenceStart >= 0) {
            reverseComplement(data, sequenceStart, length);
        }

        OutputStream out = System.out;
        out.write(data, 0, length);
        out.flush();
    }

    private static void reverseComplement(byte[] data, int left, int rightExclusive) {
        int right = rightExclusive - 1;

        while (left <= right) {
            while (left <= right && isLineBreak(data[left])) {
                left++;
            }
            while (left <= right && isLineBreak(data[right])) {
                right--;
            }

            if (left > right) {
                break;
            }

            byte a = data[left];
            byte b = data[right];
            data[left] = COMPLEMENT[b & 0xFF];
            data[right] = COMPLEMENT[a & 0xFF];

            left++;
            right--;
        }
    }

    private static boolean isLineBreak(byte value) {
        return value == '\n' || value == '\r';
    }

    private static byte[] readAll(InputStream in) throws IOException {
        byte[] buffer = new byte[1 << 20];
        int length = 0;

        while (true) {
            if (length == buffer.length) {
                buffer = Arrays.copyOf(buffer, buffer.length << 1);
            }

            int count = in.read(buffer, length, buffer.length - length);
            if (count < 0) {
                break;
            }
            if (count == 0) {
                int value = in.read();
                if (value < 0) {
                    break;
                }
                if (length == buffer.length) {
                    buffer = Arrays.copyOf(buffer, buffer.length << 1);
                }
                buffer[length++] = (byte) value;
            } else {
                length += count;
            }
        }

        return length == buffer.length ? buffer : Arrays.copyOf(buffer, length);
    }
}