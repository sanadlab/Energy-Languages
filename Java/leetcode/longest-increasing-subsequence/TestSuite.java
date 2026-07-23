// LC-energy test suite (Java) — hardcoded single case.
public class TestSuite {
    public static void main(String[] args) {
        Solution sol = new Solution();
        Object result = sol.lengthOfLIS(new int[]{1,2,3,4,5});
        if (result == null) System.out.println("null");
    }
}
