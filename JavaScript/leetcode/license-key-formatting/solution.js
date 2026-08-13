var licenseKeyFormatting = function(s, k) {
    const chars = [];
    for (const ch of s) {
        if (ch !== '-') chars.push(ch.toUpperCase());
    }
    const total = chars.length;
    if (total === 0) return "";
    let firstLen = total % k;
    if (firstLen === 0) firstLen = k;
    const parts = [];
    parts.push(chars.slice(0, firstLen).join(''));
    let idx = firstLen;
    while (idx < total) {
        parts.push(chars.slice(idx, idx + k).join(''));
        idx += k;
    }
    return parts.join('-');
};
