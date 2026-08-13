/**
 * @param {string} s
 * @return {string[]}
 */
var removeInvalidParentheses = function(s) {
    const valid = (st) => {
        let cnt = 0;
        for (const ch of st) {
            if (ch === '(') cnt++;
            else if (ch === ')') { cnt--; if (cnt < 0) return false; }
        }
        return cnt === 0;
    };
    let level = new Set([s]);
    while (level.size > 0) {
        const valids = [];
        for (const st of level) if (valid(st)) valids.push(st);
        if (valids.length > 0) return valids;
        const nxt = new Set();
        for (const st of level) {
            for (let i = 0; i < st.length; i++) {
                if (st[i] === '(' || st[i] === ')') {
                    nxt.add(st.slice(0, i) + st.slice(i + 1));
                }
            }
        }
        level = nxt;
    }
    return [""];
};
