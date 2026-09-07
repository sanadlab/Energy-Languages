"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs");
const n = Number.parseInt(process.argv[2], 10);
void n;
const input = fs.readFileSync(0, "utf8");
const originalLength = input.length;
let sequence = input.replace(/^>.*(?:\r?\n|$)|\r?\n/gm, "");
const strippedLength = sequence.length;
const patternSources = [
    "agggtaaa|tttaccct",
    "[cgt]gggtaaa|tttaccc[acg]",
    "a[act]ggtaaa|tttacc[agt]t",
    "ag[act]gtaaa|tttac[agt]ct",
    "agg[act]taaa|ttta[agt]cct",
    "aggg[acg]aaa|ttt[cgt]ccct",
    "agggt[cgt]aa|tt[acg]accct",
    "agggta[cgt]a|t[acg]taccct"
];
const output = [];
for (const source of patternSources) {
    const regex = new RegExp(source, "gi");
    let count = 0;
    while (regex.exec(sequence) !== null) {
        count++;
    }
    output.push(`${source} ${count}`);
}
const substitutions = [
    [/tHa[Nt]/g, "<4>"],
    [/aND|caN|Ha[DS]|WaS/g, "<3>"],
    [/a[NSt]|BY/g, "<2>"],
    [/<[^>]*>/g, "|"],
    [/\|[^|][^|]*\|/g, "-"]
];
for (const [regex, replacement] of substitutions) {
    sequence = sequence.replace(regex, replacement);
}
output.push(String(originalLength));
output.push(String(strippedLength));
output.push(String(sequence.length));
process.stdout.write(output.join("\n") + "\n");
