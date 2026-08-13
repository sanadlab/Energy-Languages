var StreamChecker = function(words) {
    this.root = {};
    this.stream = [];
    this.maxLen = 0;
    for (const w of words) {
        let node = this.root;
        for (let i = w.length - 1; i >= 0; i--) {
            const ch = w[i];
            if (!node[ch]) node[ch] = {};
            node = node[ch];
        }
        node.word = true;
        if (w.length > this.maxLen) this.maxLen = w.length;
    }
};

StreamChecker.prototype.query = function(letter) {
    this.stream.push(letter);
    let node = this.root;
    const n = this.stream.length;
    for (let step = 0; step < this.maxLen && step < n; step++) {
        const ch = this.stream[n - 1 - step];
        if (!node[ch]) return false;
        node = node[ch];
        if (node.word) return true;
    }
    return false;
};
