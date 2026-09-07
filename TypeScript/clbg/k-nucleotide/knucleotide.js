"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs");
const nArgument = Number.parseInt(process.argv[2], 10);
void nArgument;
const input = fs.readFileSync(0);
function upperAscii(byte) {
    return byte >= 97 && byte <= 122 ? byte - 32 : byte;
}
function isThreeHeader(start, end) {
    if (start >= end || input[start] !== 62)
        return false; // '>'
    const name = [84, 72, 82, 69, 69]; // THREE
    for (let i = 0; i < name.length; i++) {
        if (start + 1 + i >= end ||
            upperAscii(input[start + 1 + i]) !== name[i]) {
            return false;
        }
    }
    const next = start + 6;
    return next >= end || input[next] === 32 || input[next] === 9;
}
let sectionStart = -1;
let sectionEnd = input.length;
for (let lineStart = 0; lineStart < input.length;) {
    let lineEnd = lineStart;
    while (lineEnd < input.length && input[lineEnd] !== 10)
        lineEnd++;
    let contentEnd = lineEnd;
    if (contentEnd > lineStart && input[contentEnd - 1] === 13)
        contentEnd--;
    if (input[lineStart] === 62) {
        if (sectionStart >= 0) {
            sectionEnd = lineStart;
            break;
        }
        if (isThreeHeader(lineStart, contentEnd)) {
            sectionStart = lineEnd < input.length ? lineEnd + 1 : lineEnd;
        }
    }
    lineStart = lineEnd < input.length ? lineEnd + 1 : lineEnd;
}
const sequenceStorage = Buffer.allocUnsafe(input.length);
let sequenceLength = 0;
if (sectionStart >= 0) {
    for (let i = sectionStart; i < sectionEnd; i++) {
        const byte = upperAscii(input[i]);
        if (byte >= 65 && byte <= 90) {
            sequenceStorage[sequenceLength++] = byte - 65;
        }
    }
}
else {
    // Fallback for a raw sequence without a THREE header.
    for (let lineStart = 0; lineStart < input.length;) {
        let lineEnd = lineStart;
        while (lineEnd < input.length && input[lineEnd] !== 10)
            lineEnd++;
        if (input[lineStart] !== 62) {
            for (let i = lineStart; i < lineEnd; i++) {
                const byte = upperAscii(input[i]);
                if (byte >= 65 && byte <= 90) {
                    sequenceStorage[sequenceLength++] = byte - 65;
                }
            }
        }
        lineStart = lineEnd < input.length ? lineEnd + 1 : lineEnd;
    }
}
const sequence = sequenceStorage.subarray(0, sequenceLength);
const oneMerCounts = new Uint32Array(26);
const twoMerCounts = new Uint32Array(26 * 26);
for (let i = 0; i < sequenceLength; i++) {
    const current = sequence[i];
    oneMerCounts[current]++;
    if (i > 0) {
        twoMerCounts[sequence[i - 1] * 26 + current]++;
    }
}
function compareFrequencies(a, b) {
    return b.count - a.count || a.text.localeCompare(b.text);
}
const oneMerEntries = [];
for (let i = 0; i < 26; i++) {
    if (oneMerCounts[i] !== 0) {
        oneMerEntries.push({
            text: String.fromCharCode(65 + i),
            count: oneMerCounts[i]
        });
    }
}
oneMerEntries.sort(compareFrequencies);
const twoMerEntries = [];
for (let first = 0; first < 26; first++) {
    for (let second = 0; second < 26; second++) {
        const count = twoMerCounts[first * 26 + second];
        if (count !== 0) {
            twoMerEntries.push({
                text: String.fromCharCode(65 + first, 65 + second),
                count
            });
        }
    }
}
twoMerEntries.sort(compareFrequencies);
const fragmentTexts = [
    "GGT",
    "GGTA",
    "GGTATT",
    "GGTATTTTAATT",
    "GGTATTTTAATTTATAGT"
];
const fragments = fragmentTexts.map(fragment => Uint8Array.from(fragment, character => character.charCodeAt(0) - 65));
const fragmentCounts = new Uint32Array(fragments.length);
const g = 71 - 65;
const t = 84 - 65;
for (let i = 0; i + 3 <= sequenceLength; i++) {
    if (sequence[i] !== g || sequence[i + 1] !== g || sequence[i + 2] !== t) {
        continue;
    }
    fragmentCounts[0]++;
    for (let fragmentIndex = 1; fragmentIndex < fragments.length; fragmentIndex++) {
        const fragment = fragments[fragmentIndex];
        if (i + fragment.length > sequenceLength)
            break;
        let matches = true;
        for (let j = 3; j < fragment.length; j++) {
            if (sequence[i + j] !== fragment[j]) {
                matches = false;
                break;
            }
        }
        if (!matches)
            break;
        fragmentCounts[fragmentIndex]++;
    }
}
const output = [];
const oneMerTotal = sequenceLength;
for (const entry of oneMerEntries) {
    output.push(`${entry.text} ${(entry.count * 100 / oneMerTotal).toFixed(3)}`);
}
output.push("");
const twoMerTotal = Math.max(0, sequenceLength - 1);
for (const entry of twoMerEntries) {
    output.push(`${entry.text} ${(entry.count * 100 / twoMerTotal).toFixed(3)}`);
}
output.push("");
for (let i = 0; i < fragmentTexts.length; i++) {
    output.push(`${fragmentCounts[i]}\t${fragmentTexts[i]}`);
}
process.stdout.write(output.join("\n") + "\n");
