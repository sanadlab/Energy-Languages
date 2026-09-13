import java.math.BigInteger;

public class pidigits {
    public static void main(String[] args) {
        final int n = Integer.parseInt(args[0]);
        final BigInteger THREE = BigInteger.valueOf(3);
        final BigInteger TEN = BigInteger.TEN;

        BigInteger numerator = BigInteger.ONE;
        BigInteger denominator = BigInteger.ONE;
        BigInteger accumulator = BigInteger.ZERO;

        StringBuilder output = new StringBuilder();
        int emitted = 0;
        long k = 0;

        while (emitted < n) {
            ++k;
            BigInteger factor = BigInteger.valueOf(2 * k + 1);

            accumulator = accumulator.add(numerator.shiftLeft(1)).multiply(factor);
            numerator = numerator.multiply(BigInteger.valueOf(k));
            denominator = denominator.multiply(factor);

            if (numerator.compareTo(accumulator) > 0) {
                continue;
            }

            BigInteger tripleNumerator = numerator.multiply(THREE);
            BigInteger[] candidate = accumulator.add(tripleNumerator)
                    .divideAndRemainder(denominator);

            if (candidate[1].add(numerator).compareTo(denominator) >= 0) {
                continue;
            }

            output.append((char) ('0' + candidate[0].intValue()));
            ++emitted;

            if (emitted % 10 == 0) {
                output.append('\t').append(':').append(emitted).append('\n');
            }

            accumulator = candidate[1].subtract(tripleNumerator).multiply(TEN);
            numerator = numerator.multiply(TEN);
        }

        int remaining = emitted % 10;
        if (remaining != 0) {
            for (int i = remaining; i < 10; ++i) {
                output.append(' ');
            }
            output.append('\t').append(':').append(emitted).append('\n');
        }

        System.out.print(output);
    }
}