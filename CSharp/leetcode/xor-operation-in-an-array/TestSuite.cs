// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.XorOperation(20, 20);
        if (result == null) System.Console.WriteLine(result);
    }
}
