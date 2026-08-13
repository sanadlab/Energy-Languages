class Solution {
    licenseKeyFormatting(s: string, k: number): string {
        const cleaned = s.replace(/-/g, '').toUpperCase();
        const L = cleaned.length;
        if (L === 0) return '';

        const m = L % k;
        const groups: string[] = [];
        if (m > 0) groups.push(cleaned.slice(0, m));
        for (let i = m; i < L; i += k) {
            groups.push(cleaned.slice(i, i + k));
        }

        return groups.join('-');
    }
}