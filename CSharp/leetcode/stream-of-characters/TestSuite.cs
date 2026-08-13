// LC-energy test suite (C#) — hardcoded single case.
public class TestSuite {
    public static void Main() {
        var sc = new StreamChecker(new string[]{"a","b","c"});
        bool r = sc.Query('a');
        if (r) System.Console.WriteLine(r);
    }
}
