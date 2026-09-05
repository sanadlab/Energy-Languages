const fs = require('fs');
const input = fs.readFileSync(0, 'utf8');
// FASTA strip: remove headers and newlines
// Count original length before stripping
const originalLength = input.length;
// Build stripped sequence efficiently
let seq = '';
{
    const lines = input.split('\n');
    const parts = [];
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        if (line.length === 0)
            continue;
        if (line.charCodeAt(0) !== 62)
            parts.push(line); // '>'
    }
    seq = parts.join('');
}
const strippedLength = seq.length;
// Patterns from the classic regex-redux benchmark
const patterns = [
    [/agggtaaa|tttaccct/ig, 'agggtaaa|tttaccct'],
    [/[cgt]gggtaaa|tttaccc[acg]/ig, '[cgt]gggtaaa|tttaccc[acg]'],
    [/a[act]ggtaaa|tttacc[agt]t/ig, 'a[act]ggtaaa|tttacc[agt]t'],
    [/ag[act]gtaaa|tttac[agt]ct/ig, 'ag[act]gtaaa|tttac[agt]ct'],
    [/agg[act]taaa|ttta[agt]cct/ig, 'agg[act]taaa|ttta[agt]cct'],
    [/aggg[acg]aaa|ttt[cgt]ccct/ig, 'aggg[acg]aaa|ttt[cgt]ccct'],
    [/agggt[cgt]aa|tt[acg]accct/ig, 'agggt[cgt]aa|tt[acg]accct'],
    [/agggta[cgt]a|t[acg]taccct/ig, 'agggta[cgt]a|t[acg]taccct'],
];
// Count occurrences
const out = [];
for (let i = 0; i < patterns.length; i++) {
    const [re, text] = patterns[i];
    const m = seq.match(re);
    out.push(`${text} ${(m === null) ? 0 : m.length}`);
}
// IUPAC-encoded substitutions
// Order matters; these are the standard regex-redux replacements.
const substitutions = [
    [/B/g, '(c|g|t)'],
    [/D/g, '(a|g|t)'],
    [/H/g, '(a|c|t)'],
    [/K/g, '(g|t)'],
    [/M/g, '(a|c)'],
    [/N/g, '(a|c|g|t)'],
    [/R/g, '(a|g)'],
    [/S/g, '(c|g)'],
    [/V/g, '(a|c|g)'],
    [/W/g, '(a|t)'],
    [/Y/g, '(c|t)'],
];
let replaced = seq;
for (let i = 0; i < substitutions.length; i++) {
    const [re, rep] = substitutions[i];
    replaced = replaced.replace(re, rep);
}
const postSubLength = replaced.length;
out.push(String(originalLength));
out.push(String(strippedLength));
out.push(String(postSubLength));
process.stdout.write(out.join('\n'));
