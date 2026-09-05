const N = parseInt(process.argv[2] ?? "0", 10);
function main(n) {
    // Rabinowitz and Wagon unbounded spigot algorithm for pi digits.
    // Generates decimal digits sequentially with arbitrary-precision integers using BigInt.
    // The number of extra terms needed is roughly 10*n/3, plus a small buffer.
    const len = Math.floor((10 * n) / 3) + 1;
    const a = new Array(len).fill(2n);
    let nines = 0;
    let predigit = 0;
    let out = "";
    let lineDigits = 0;
    let produced = 0;
    function emitDigit(d) {
        out += String.fromCharCode(48 + d);
        lineDigits++;
        produced++;
        if (lineDigits === 10 || produced === n) {
            out += "\t:" + produced.toString() + "\n";
            lineDigits = 0;
        }
    }
    for (let j = 0; produced < n; j++) {
        let q = 0n;
        for (let i = len - 1; i >= 0; i--) {
            const x = a[i] * 10n + q * BigInt(i + 1);
            const d = BigInt(2 * i + 1);
            a[i] = x % d;
            q = x / d * BigInt(i);
        }
        a[0] = q % 10n;
        q = q / 10n;
        if (q === 9n) {
            nines++;
        }
        else if (q === 10n) {
            emitDigit(predigit + 1);
            for (; nines > 0; nines--)
                emitDigit(0);
            predigit = 0;
        }
        else {
            emitDigit(predigit);
            predigit = Number(q);
            if (nines > 0) {
                for (; nines > 0; nines--)
                    emitDigit(9);
            }
        }
        if (produced === 0 && j === 0) {
            // No-op, kept for clarity; predigit handling starts after first iteration.
        }
    }
    // If the loop ended with a pending predigit not yet emitted, emit it.
    // This can happen when the exact target count is reached mid-stream.
    if (produced < n) {
        emitDigit(predigit);
        while (produced < n)
            emitDigit(0);
    }
    process.stdout.write(out);
}
main(N);
