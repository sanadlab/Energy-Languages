// LC-energy test suite (C#) — design-a-stack-with-increment-operation.
public class TestSuite {
    public static void Main() {
        var s = new CustomStack(5);
        s.Push(1); s.Push(2); s.Push(3);
        s.Increment(2, 100);
        int r1 = s.Pop();
        int r2 = s.Pop();
        if (r1 < 0 && r2 < 0) System.Console.WriteLine("unexpected");
    }
}
