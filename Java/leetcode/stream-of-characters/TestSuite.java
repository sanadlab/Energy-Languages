// LC-energy test suite (Java) — hardcoded single case.
public class TestSuite {
    public static void main(String[] args) {
        StreamChecker sc = new StreamChecker(new String[]{"a","b","c"});
        boolean r = sc.query('a');
        if (r) System.out.println(r);
    }
}
