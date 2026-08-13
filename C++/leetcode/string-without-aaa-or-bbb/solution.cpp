class Solution {
public:
    string strWithout3a3b(int a, int b) {
        string res;
        while (a > 0 || b > 0) {
            bool writeA;
            int n = res.size();
            if (n >= 2 && res[n-1] == res[n-2]) writeA = (res[n-1] == 'b');
            else writeA = (a >= b);
            if (writeA) {
                if (a == 0) break;
                res += 'a'; a--;
            } else {
                if (b == 0) break;
                res += 'b'; b--;
            }
        }
        return res;
    }
};
