const N = parseInt(process.argv[2] || "0", 10);
const IM = 139968;
const IA = 3877;
const IC = 29573;
let seed = 42;
function genRandom() {
    seed = (seed * IA + IC) % IM;
    return seed / IM;
}
function makeCumulative(table) {
    let sum = 0;
    return table.map(([c, p]) => {
        sum += p;
        return [c, sum];
    });
}
const iub = makeCumulative([
    ["a", 0.27],
    ["c", 0.12],
    ["g", 0.12],
    ["t", 0.27],
    ["B", 0.02],
    ["D", 0.02],
    ["H", 0.02],
    ["K", 0.02],
    ["M", 0.02],
    ["N", 0.02],
    ["R", 0.02],
    ["S", 0.02],
    ["V", 0.02],
    ["W", 0.02],
    ["Y", 0.02],
]);
const homo = makeCumulative([
    ["a", 0.3029549426680],
    ["c", 0.1979883004921],
    ["g", 0.1975473066391],
    ["t", 0.3015094502008],
]);
const alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
    "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
    "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
    "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
    "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
    "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
    "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
let out = [];
function emitHeader(s) {
    out.push(s);
}
function writeRepeat(seq, length) {
    const slen = seq.length;
    let idx = 0;
    let line = "";
    for (let i = 0; i < length; i++) {
        line += seq[idx];
        idx++;
        if (idx === slen)
            idx = 0;
        if (line.length === 60) {
            out.push(line);
            line = "";
        }
    }
    if (line.length)
        out.push(line);
}
function writeRandom(cum, length) {
    let line = "";
    for (let i = 0; i < length; i++) {
        const r = genRandom();
        let lo = 0, hi = cum.length - 1;
        while (lo < hi) {
            const mid = (lo + hi) >> 1;
            if (r < cum[mid][1])
                hi = mid;
            else
                lo = mid + 1;
        }
        line += cum[lo][0];
        if (line.length === 60) {
            out.push(line);
            line = "";
        }
    }
    if (line.length)
        out.push(line);
}
emitHeader(">ONE Homo sapiens alu");
writeRepeat(alu, 2 * N);
emitHeader(">TWO IUB ambiguity codes");
writeRandom(iub, 3 * N);
emitHeader(">THREE Homo sapiens frequency");
writeRandom(homo, 5 * N);
process.stdout.write(out.join("\n") + "\n");
