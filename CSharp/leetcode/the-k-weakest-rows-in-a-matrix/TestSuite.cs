// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.KWeakestRows(new int[][]{new int[]{1,2},new int[]{3,4}}, 20);
        if (result == null) System.Console.WriteLine(result);
    }
}
