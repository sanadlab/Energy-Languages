import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class regexredux {
    private static final String[] VARIANT_STRINGS = {
        "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct",
        "agggtaa[cgt]|[acg]ttaccct"
    };

    private static final Pattern[] VARIANTS = new Pattern[VARIANT_STRINGS.length];

    private static final Pattern[] SUBSTITUTION_PATTERNS = {
        Pattern.compile("tHa[Nt]"),
        Pattern.compile("aND|caN|Ha[DS]|WaS"),
        Pattern.compile("a[NSt]|BY"),
        Pattern.compile("<[^>]*>"),
        Pattern.compile("\\|[^|][^|]*\\|")
    };

    private static final String[] REPLACEMENTS = {
        "<4>",
        "<3>",
        "<2>",
        "|",
        "-"
    };

    static {
        for (int i = 0; i < VARIANT_STRINGS.length; i++) {
            VARIANTS[i] = Pattern.compile(VARIANT_STRINGS[i]);
        }
    }

    public static void main(String[] args) throws Exception {
        Integer.parseInt(args[0]);

        byte[] input = readAllInput();
        int originalLength = input.length;
        int strippedLength = stripFastaInPlace(input);

        String sequence = new String(
            input, 0, strippedLength, StandardCharsets.ISO_8859_1
        );

        StringBuilder output = new StringBuilder(512);

        for (int i = 0; i < VARIANTS.length; i++) {
            Matcher matcher = VARIANTS[i].matcher(sequence);
            long count = 0;
            while (matcher.find()) {
                count++;
            }

            output.append(VARIANT_STRINGS[i])
                  .append(' ')
                  .append(count)
                  .append('\n');
        }

        String substituted = sequence;
        for (int i = 0; i < SUBSTITUTION_PATTERNS.length; i++) {
            substituted = SUBSTITUTION_PATTERNS[i]
                .matcher(substituted)
                .replaceAll(REPLACEMENTS[i]);
        }

        output.append('\n')
              .append(originalLength).append('\n')
              .append(strippedLength).append('\n')
              .append(substituted.length()).append('\n');

        System.out.print(output);
    }

    private static byte[] readAllInput() throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream(1 << 20);
        byte[] block = new byte[1 << 16];
        int count;

        while ((count = System.in.read(block)) != -1) {
            buffer.write(block, 0, count);
        }

        return buffer.toByteArray();
    }

    private static int stripFastaInPlace(byte[] data) {
        int write = 0;
        boolean atLineStart = true;
        boolean inHeader = false;

        for (byte value : data) {
            int c = value & 0xff;

            if (inHeader) {
                if (c == '\n' || c == '\r') {
                    inHeader = false;
                    atLineStart = true;
                }
                continue;
            }

            if (c == '\n' || c == '\r') {
                atLineStart = true;
            } else if (atLineStart && c == '>') {
                inHeader = true;
            } else {
                data[write++] = value;
                atLineStart = false;
            }
        }

        return write;
    }
}