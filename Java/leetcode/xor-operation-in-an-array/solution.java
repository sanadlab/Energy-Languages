import java.util.stream.IntStream;

class Solution {
    public int xorOperation(int n, int start) {
        return IntStream.range(0, n)
                        .map(i -> start + 2 * i)
                        .reduce(0, (a, b) -> a ^ b);
    }
}