class Solution {
public:
    string abbreviateProduct(int left, int right) {
        long long SUFMOD = 10000000000000LL; // 1e13
        long long suf = 1;
        double pre = 1.0;
        long long c2 = 0, c5 = 0;
        long long extra = 0;
        for (int i = left; i <= right; ++i) {
            int x = i;
            while (x % 2 == 0) { x /= 2; ++c2; }
            while (x % 5 == 0) { x /= 5; ++c5; }
            suf = (suf * x) % SUFMOD;
            pre *= i;
            while (pre >= 1e15) { pre /= 10; ++extra; }
        }
        long long C = min(c2, c5);
        long long r2 = c2 - C, r5 = c5 - C;
        for (long long k = 0; k < r2; ++k) suf = (suf * 2) % SUFMOD;
        for (long long k = 0; k < r5; ++k) suf = (suf * 5) % SUFMOD;
        double tmp = pre;
        long long intdigits = 1;
        while (tmp >= 10) { tmp /= 10; ++intdigits; }
        long long Nfull = extra + intdigits;
        long long d = Nfull - C;
        if (d <= 10) {
            return to_string(suf) + "e" + to_string(C);
        }
        double lead = pre;
        while (lead >= 100000) lead /= 10;
        while (lead < 10000) lead *= 10;
        long long first5 = (long long)lead;
        long long last5 = suf % 100000;
        string ls = to_string(last5);
        while ((int)ls.size() < 5) ls = "0" + ls;
        return to_string(first5) + "..." + ls + "e" + to_string(C);
    }
};
