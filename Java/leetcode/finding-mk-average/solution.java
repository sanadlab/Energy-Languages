import java.util.*;

class Solution {
    private int m, k;
    private List<Integer> stream = new ArrayList<>();

    public Solution() { this.m = 0; this.k = 0; }
    public Solution(int m, int k) { this.m = m; this.k = k; }

    public void addElement(int num) {
        stream.add(num);
    }

    public int calculateMKAverage() {
        int n = stream.size();
        if (n < m) return -1;
        List<Integer> last = new ArrayList<>(stream.subList(n - m, n));
        Collections.sort(last);
        long sum = 0;
        int cnt = 0;
        for (int i = k; i < m - k; i++) {
            sum += last.get(i);
            cnt++;
        }
        if (cnt == 0) return 0;
        return (int)(sum / cnt);
    }
}
