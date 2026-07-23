// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.ValidateBinaryTreeNodes(20, new int[]{1,2,3,4,5}, new int[]{1,2,3,4,5});
        if (result == null) System.Console.WriteLine(result);
    }
}
