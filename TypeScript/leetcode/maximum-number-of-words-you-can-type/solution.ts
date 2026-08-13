function canBeTypedWords(text: string, brokenLetters: string): number {
    const broken = new Set(brokenLetters);
    let count = 0;
    for (const word of text.split(' ')) {
        let ok = true;
        for (const c of word) {
            if (broken.has(c)) { ok = false; break; }
        }
        if (ok) count++;
    }
    return count;
}
