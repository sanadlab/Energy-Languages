// LC-energy test suite (Java) — hardcoded single case.
public class TestSuite {
    public static void main(String[] args) {
        Solution sol = new Solution();
        Object result = sol.closeStrings("abcde", "abcde");
        if (result == null) System.out.println("null");
    }
}
