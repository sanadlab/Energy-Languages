// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sol = new Solution();
        var result = sol.DaysBetweenDates("abcde", "abcde");
        if (result == null) System.Console.WriteLine(result);
    }
}
