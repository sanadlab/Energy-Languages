class Solution {
public:
    string licenseKeyFormatting(string s, int k) {
        string filtered;
        // Remove dashes and convert to uppercase
        for (char c : s) {
            if (c != '-') {
                filtered += toupper(c);
            }
        }
        
        int n = filtered.size();
        if (n == 0) return "";
        
        int firstGroupLen = n % k;
        if (firstGroupLen == 0) firstGroupLen = k;
        
        string result = filtered.substr(0, firstGroupLen);
        for (int i = firstGroupLen; i < n; i += k) {
            result += '-';
            result += filtered.substr(i, k);
        }
        
        return result;
    }
};