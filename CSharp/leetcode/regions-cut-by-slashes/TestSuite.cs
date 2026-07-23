// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.RegionsBySlashes(new string[]{"a","b","c"});
        if (result == null) System.Console.WriteLine(result);
    }
}
