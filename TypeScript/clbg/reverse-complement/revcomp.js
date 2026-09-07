"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs");
const n = Number.parseInt(process.argv[2], 10);
void n;
const data = fs.readFileSync(0);
const complement = Buffer.allocUnsafe(256);
for (let i = 0; i < 256; i++) {
    complement[i] = i;
}
const source = "ACBDGHKMNSRUTWVYacbdghkmnsrutwvy";
const target = "TGVHCDMKNSYAAWBRTGVHCDMKNSYAAWBR";
for (let i = 0; i < source.length; i++) {
    complement[source.charCodeAt(i)] = target.charCodeAt(i);
}
function reverseComplement(start, end) {
    let left = start;
    let right = end - 1;
    while (left <= right) {
        while (left <= right && (data[left] === 10 || data[left] === 13)) {
            left++;
        }
        while (left <= right && (data[right] === 10 || data[right] === 13)) {
            right--;
        }
        if (left > right) {
            break;
        }
        if (left === right) {
            data[left] = complement[data[left]];
            break;
        }
        const leftBase = data[left];
        const rightBase = data[right];
        data[left] = complement[rightBase];
        data[right] = complement[leftBase];
        left++;
        right--;
    }
}
let sequenceStart = -1;
let position = 0;
while (position < data.length) {
    if (data[position] === 62 &&
        (position === 0 || data[position - 1] === 10)) {
        if (sequenceStart >= 0) {
            reverseComplement(sequenceStart, position);
        }
        const newline = data.indexOf(10, position);
        if (newline === -1) {
            sequenceStart = data.length;
            position = data.length;
            break;
        }
        sequenceStart = newline + 1;
        position = sequenceStart;
    }
    else {
        position++;
    }
}
if (sequenceStart >= 0 && sequenceStart < data.length) {
    reverseComplement(sequenceStart, data.length);
}
process.stdout.write(data);
