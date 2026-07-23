// LC-energy test suite (Java) — hardcoded single case.
public class TestSuite {
    public static void main(String[] args) {
        Solution sol = new Solution();
        Object result = sol.ladderLength("abcde", "abcde", new String[]{"a","b","c"});
        if (result == null) System.out.println("null");
    }
}
