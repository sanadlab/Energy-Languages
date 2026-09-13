import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class regexredux {
    private static final String[] VARIANTS = {
        "agggtaaa|tttaccct",
        "[cgt]gggtaaa|tttaccc[acg]",
        "a[act]ggtaaa|tttacc[agt]t",
        "ag[act]gtaaa|tttac[agt]ct",
        "agg[act]taaa|ttta[agt]cct",
        "aggg[acg]aaa|ttt[cgt]ccct",
        "agggt[cgt]aa|tt[acg]accct",
        "agggta[cgt]a|t[acg]taccct"
    };

    private static final String[] SUBSTITUTIONS = {
        "tHa[Nt]",
        "aND|caN|Ha[DS]|WaS",
        "a[NSt]|BY",
        "<[^>]*>",
        "\\|[^|][^|]*\\|"
    };

    private static final String[] REPLACEMENTS = {
        "<4>", "<3>", "<2>", "|", "-"
    };

    private static String readInput() throws IOException {
        return new String(System.in.readAllBytes(), StandardCharsets.ISO_8859_1);
    }

    public static void main(String[] args) throws Exception {
        int n = Integer.parseInt(args[0]);

        String input = readInput();
        int originalLength = input.length();

        final String sequence = Pattern.compile(">[^\\n]*\\n|\\n")
                .matcher(input)
                .replaceAll("");
        int strippedLength = sequence.length();
        input = null;

        int workers = Math.max(1, Math.min(
                VARIANTS.length, Runtime.getRuntime().availableProcessors()));
        ExecutorService executor = Executors.newFixedThreadPool(workers);

        try {
            List<Future<Integer>> counts = new ArrayList<>(VARIANTS.length);

            for (String variant : VARIANTS) {
                counts.add(executor.submit(() -> {
                    Matcher matcher = Pattern.compile(variant).matcher(sequence);
                    int count = 0;
                    while (matcher.find()) {
                        count++;
                    }
                    return count;
                }));
            }

            String encoded = sequence;
            for (int i = 0; i < SUBSTITUTIONS.length; i++) {
                encoded = Pattern.compile(SUBSTITUTIONS[i])
                        .matcher(encoded)
                        .replaceAll(REPLACEMENTS[i]);
            }

            StringBuilder output = new StringBuilder(512);
            for (int i = 0; i < VARIANTS.length; i++) {
                output.append(VARIANTS[i]).append(' ')
                        .append(counts.get(i).get()).append('\n');
            }

            output.append(originalLength).append('\n')
                    .append(strippedLength).append('\n')
                    .append(encoded.length()).append('\n');

            System.out.print(output);
        } finally {
            executor.shutdown();
        }
    }
}