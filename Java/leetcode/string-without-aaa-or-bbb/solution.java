class Solution {
    public String strWithout3a3b(int a, int b) {
        StringBuilder sb = new StringBuilder();
        while (a > 0 || b > 0) {
            boolean writeA;
            int n = sb.length();
            if (n >= 2 && sb.charAt(n-1) == sb.charAt(n-2)) writeA = sb.charAt(n-1) == 'b';
            else writeA = a >= b;
            if (writeA) {
                if (a == 0) break;
                sb.append('a'); a--;
            } else {
                if (b == 0) break;
                sb.append('b'); b--;
            }
        }
        return sb.toString();
    }
}
