function ladderLength(beginWord: string, endWord: string, wordList: string[]): number {
    const dict = new Set(wordList);
    if (!dict.has(endWord)) return 0;
    let queue: string[] = [beginWord];
    const visited = new Set<string>([beginWord]);
    let level = 1;
    while (queue.length) {
        const next: string[] = [];
        for (const word of queue) {
            if (word === endWord) return level;
            const arr = word.split("");
            for (let i = 0; i < arr.length; i++) {
                const old = arr[i];
                for (let c = 97; c <= 122; c++) {
                    const ch = String.fromCharCode(c);
                    if (ch === old) continue;
                    arr[i] = ch;
                    const cand = arr.join("");
                    if (dict.has(cand) && !visited.has(cand)) {
                        visited.add(cand);
                        next.push(cand);
                    }
                }
                arr[i] = old;
            }
        }
        queue = next;
        level++;
    }
    return 0;
}
