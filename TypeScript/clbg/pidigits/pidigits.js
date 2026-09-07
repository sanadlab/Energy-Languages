const limit = Number.parseInt(process.argv[2], 10);
let q = 1n;
let r = 0n;
let t = 1n;
let k = 1n;
let digit = 3n;
let l = 3n;
let produced = 0;
let group = "";
const lines = [];
while (produced < limit) {
    if (4n * q + r - t < digit * t) {
        group += digit.toString();
        produced++;
        if (group.length === 10) {
            lines.push(`${group}\t:${produced}`);
            group = "";
        }
        const nextR = 10n * (r - digit * t);
        digit = (10n * (3n * q + r)) / t - 10n * digit;
        q *= 10n;
        r = nextR;
    }
    else {
        const nextR = (2n * q + r) * l;
        const nextT = t * l;
        const nextDigit = (q * (7n * k) + 2n + r * l) / nextT;
        q *= k;
        t = nextT;
        r = nextR;
        k += 1n;
        l += 2n;
        digit = nextDigit;
    }
}
if (group.length > 0) {
    lines.push(`${group.padEnd(10, " ")}\t:${produced}`);
}
process.stdout.write(lines.join("\n") + "\n");
