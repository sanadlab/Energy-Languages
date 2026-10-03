class Solution {
    fun licenseKeyFormatting(s: String, k: Int): String {
        val cleaned = s.replace("-", "").uppercase()
        val firstGroupLen = cleaned.length % k
        val result = ArrayList<String>()
        if (firstGroupLen > 0) {
            result.add(cleaned.substring(0, firstGroupLen))
        }
        var i = firstGroupLen
        while (i < cleaned.length) {
            result.add(cleaned.substring(i, minOf(i + k, cleaned.length)))
            i += k
        }
        return result.joinToString("-")
    }
}
