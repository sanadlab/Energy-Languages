// LC-energy test suite (Java) — hardcoded single case.
public class TestSuite {
    public static void main(String[] args) {
        Solution sol = new Solution();
        Object result = sol.kWeakestRows(new int[][]{{1,2},{3,4}}, 20);
        if (result == null) System.out.println("null");
    }
}
