// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.MaxStudents(new char[][]{new char[]{'a','b'},new char[]{'c','d'}});
        if (result == null) System.Console.WriteLine(result);
    }
}
