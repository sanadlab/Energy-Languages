// LC-energy test suite (Java) — design-a-stack-with-increment-operation.
public class TestSuite {
    public static void main(String[] args) {
        CustomStack s = new CustomStack(5);
        s.push(1); s.push(2); s.push(3);
        s.increment(2, 100);
        int r1 = s.pop();
        int r2 = s.pop();
        if (r1 < 0 && r2 < 0) System.out.println("unexpected");
    }
}
