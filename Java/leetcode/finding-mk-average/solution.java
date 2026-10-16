import java.util.*;
import java.util.stream.*;
import java.math.*;

class MKAverage {
    // The last m elements split into three sorted multisets: the k smallest
    // (lo), the middle m - 2k (mid, with its sum), and the k largest (hi).
    private final int m, k;
    private final Deque<Integer> window = new ArrayDeque<>();
    private final TreeMap<Integer, Integer> lo = new TreeMap<>(), mid = new TreeMap<>(), hi = new TreeMap<>();
    private int loN = 0, midN = 0, hiN = 0;
    private long midSum = 0;

    public MKAverage(int m, int k) {
        this.m = m;
        this.k = k;
    }

    private static void add(TreeMap<Integer, Integer> t, int x) { t.merge(x, 1, Integer::sum); }

    private static void remove(TreeMap<Integer, Integer> t, int x) {
        if (t.merge(x, -1, Integer::sum) == 0) t.remove(x);
    }

    public void addElement(int num) {
        window.addLast(num);
        add(lo, num); loN++;
        if (loN > k) { int x = lo.lastKey(); remove(lo, x); loN--; add(mid, x); midN++; midSum += x; }
        if (midN > m - 2 * k) { int x = mid.lastKey(); remove(mid, x); midN--; midSum -= x; add(hi, x); hiN++; }
        if (window.size() > m) {
            int old = window.pollFirst();
            if (lo.containsKey(old)) { remove(lo, old); loN--; }
            else if (mid.containsKey(old)) { remove(mid, old); midN--; midSum -= old; }
            else { remove(hi, old); hiN--; }
            if (loN < k && midN > 0) { int x = mid.firstKey(); remove(mid, x); midN--; midSum -= x; add(lo, x); loN++; }
            if (midN < m - 2 * k && hiN > 0) { int x = hi.firstKey(); remove(hi, x); hiN--; add(mid, x); midN++; midSum += x; }
        }
    }

    public int calculateMKAverage() {
        return window.size() < m ? -1 : (int) (midSum / (m - 2 * k));
    }
}
