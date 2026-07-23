// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.Shuffle(new int[]{1,2,3,4,5}, 20);
        if (result == null) System.Console.WriteLine(result);
    }
}
