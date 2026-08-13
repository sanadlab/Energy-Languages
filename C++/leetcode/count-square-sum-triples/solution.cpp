class Solution {
public:
    int countTriples(int n) {
        int count = 0;
        for (int a = 1; a <= n; a++) {
            for (int b = 1; b <= n; b++) {
                int c2 = a * a + b * b;
                int c = (int)(sqrt((double)c2) + 0.5);
                if (c >= 1 && c <= n && c * c == c2) count++;
            }
        }
        return count;
    }
};
