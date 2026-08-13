public class Solution {
    public string AbbreviateProduct(int left, int right) {
        long SUFMOD = 10000000000000L; // 1e13
        long suf = 1;
        double pre = 1.0;
        long c2 = 0, c5 = 0;
        long extra = 0;
        for (int i = left; i <= right; i++) {
            int x = i;
            while (x % 2 == 0) { x /= 2; c2++; }
            while (x % 5 == 0) { x /= 5; c5++; }
            suf = (suf * x) % SUFMOD;
            pre *= i;
            while (pre >= 1e15) { pre /= 10; extra++; }
        }
        long C = c2 < c5 ? c2 : c5;
        long r2 = c2 - C, r5 = c5 - C;
        for (long k = 0; k < r2; k++) suf = (suf * 2) % SUFMOD;
        for (long k = 0; k < r5; k++) suf = (suf * 5) % SUFMOD;
        double tmp = pre;
        long intdigits = 1;
        while (tmp >= 10) { tmp /= 10; intdigits++; }
        long Nfull = extra + intdigits;
        long d = Nfull - C;
        if (d <= 10) {
            return suf.ToString() + "e" + C.ToString();
        }
        double lead = pre;
        while (lead >= 100000) lead /= 10;
        while (lead < 10000) lead *= 10;
        long first5 = (long)lead;
        long last5 = suf % 100000;
        return first5.ToString() + "..." + last5.ToString().PadLeft(5, '0') + "e" + C.ToString();
    }
}
