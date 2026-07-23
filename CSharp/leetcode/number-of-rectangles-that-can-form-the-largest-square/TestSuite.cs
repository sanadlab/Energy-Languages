// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.CountGoodRectangles(new int[][]{new int[]{1,2},new int[]{3,4}});
        if (result == null) System.Console.WriteLine(result);
    }
}
