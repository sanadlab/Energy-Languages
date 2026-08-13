var uncommonFromSentences = function(s1, s2) {
    const cnt = {};
    for (const w of (s1 + " " + s2).split(" ")) {
        if (w === "") continue;
        cnt[w] = (cnt[w] || 0) + 1;
    }
    return Object.keys(cnt).filter(w => cnt[w] === 1);
};
