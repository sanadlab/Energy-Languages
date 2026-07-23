// LC-energy test suite (Java) — hardcoded single case.
public class TestSuite {
    public static void main(String[] args) {
        Solution sol = new Solution();
        Object result = sol.friendRequests(20, new int[][]{{1,2},{3,4}}, new int[][]{{1,2},{3,4}});
        if (result == null) System.out.println("null");
    }
}
