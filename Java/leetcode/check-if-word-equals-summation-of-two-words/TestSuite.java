// LC-energy test suite (Java) — hardcoded single case.
public class TestSuite {
    public static void main(String[] args) {
        Solution sol = new Solution();
        Object result = sol.isSumEqual("abcde", "abcde", "abcde");
        if (result == null) System.out.println("null");
    }
}
