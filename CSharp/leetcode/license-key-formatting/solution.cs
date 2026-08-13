public class Solution {
    public string LicenseKeyFormatting(string s, int k) {
        string processed = s.Replace("-", "").ToUpper();
        if (string.IsNullOrEmpty(processed)) return "";
        
        int L = processed.Length;
        int firstGroupLength = (L % k) == 0 ? k : (L % k);
        
        string result = processed.Substring(0, firstGroupLength);
        int start = firstGroupLength;
        
        while (start < L) {
            result += '-';
            result += processed.Substring(start, k);
            start += k;
        }
        
        return result;
    }
}