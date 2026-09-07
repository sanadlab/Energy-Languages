import java.math.BigInteger;

class pidigits {
    private static final BigInteger TWO = BigInteger.valueOf(2);
    private static final BigInteger THREE = BigInteger.valueOf(3);
    private static final BigInteger FOUR = BigInteger.valueOf(4);
    private static final BigInteger SEVEN = BigInteger.valueOf(7);
    private static final BigInteger TEN = BigInteger.TEN;

    public static void main(String[] args) {
        int limit = Integer.parseInt(args[0]);

        BigInteger q = BigInteger.ONE;
        BigInteger r = BigInteger.ZERO;
        BigInteger t = BigInteger.ONE;

        long k = 1;
        long l = 3;
        int digit = 3;
        int produced = 0;

        StringBuilder output = new StringBuilder(limit + (limit / 10 + 1) * 16);

        while (produced < limit) {
            BigInteger digitTimesT = t.multiply(BigInteger.valueOf(digit));
            BigInteger test = q.multiply(FOUR).add(r).subtract(t);

            if (test.compareTo(digitTimesT) < 0) {
                output.append((char) ('0' + digit));
                produced++;

                if (produced % 10 == 0) {
                    output.append('\t').append(':').append(produced).append('\n');
                }

                BigInteger oldQ = q;
                BigInteger oldR = r;

                q = oldQ.multiply(TEN);
                r = oldR.subtract(digitTimesT).multiply(TEN);
                digit = oldQ.multiply(THREE)
                            .add(oldR)
                            .multiply(TEN)
                            .divide(t)
                            .intValue() - 10 * digit;
            } else {
                BigInteger oldQ = q;
                BigInteger oldR = r;
                BigInteger kValue = BigInteger.valueOf(k);
                BigInteger lValue = BigInteger.valueOf(l);

                BigInteger newT = t.multiply(lValue);
                BigInteger newR = oldQ.multiply(TWO).add(oldR).multiply(lValue);

                digit = oldQ.multiply(kValue.multiply(SEVEN))
                            .add(TWO)
                            .add(oldR.multiply(lValue))
                            .divide(newT)
                            .intValue();

                q = oldQ.multiply(kValue);
                r = newR;
                t = newT;
                k++;
                l += 2;
            }
        }

        int remainder = limit % 10;
        if (remainder != 0) {
            for (int i = remainder; i < 10; i++) {
                output.append(' ');
            }
            output.append('\t').append(':').append(limit).append('\n');
        }

        System.out.print(output);
    }
}