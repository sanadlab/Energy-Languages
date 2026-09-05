const { Worker } = require("worker_threads");
const os = require("os");
const n = Number.parseInt(process.argv[2], 10);
const factorial = new Array(n + 1);
factorial[0] = 1;
for (let i = 1; i <= n; i++) {
    factorial[i] = factorial[i - 1] * i;
}
const totalPermutations = factorial[n];
const workerSource = `
"use strict";

const { parentPort, workerData } = require("worker_threads");

function run(n, start, end) {
    const factorial = new Array(n + 1);
    factorial[0] = 1;
    for (let i = 1; i <= n; i++) {
        factorial[i] = factorial[i - 1] * i;
    }

    const permutation = new Int32Array(n);
    const scratch = new Int32Array(n);
    const count = new Int32Array(n);

    for (let i = 0; i < n; i++) {
        permutation[i] = i;
    }

    let remainder = start;

    for (let i = n - 1; i > 0; i--) {
        const digit = Math.floor(remainder / factorial[i]);
        count[i] = digit;
        remainder %= factorial[i];

        if (digit !== 0) {
            for (let j = 0; j <= i; j++) {
                scratch[j] = permutation[j];
            }
            const length = i + 1;
            for (let j = 0; j <= i; j++) {
                permutation[j] = scratch[(j + digit) % length];
            }
        }
    }

    let checksum = 0;
    let maxFlips = 0;
    let sign = (start % 2 === 0) ? 1 : -1;

    for (let index = start; index < end; index++) {
        let first = permutation[0];

        if (first !== 0) {
            scratch.set(permutation);

            let flips = 0;
            while (first !== 0) {
                let left = 0;
                let right = first;

                while (left < right) {
                    const value = scratch[left];
                    scratch[left] = scratch[right];
                    scratch[right] = value;
                    left++;
                    right--;
                }

                flips++;
                first = scratch[0];
            }

            checksum += sign * flips;
            if (flips > maxFlips) {
                maxFlips = flips;
            }
        }

        sign = -sign;

        if (index + 1 < end) {
            for (let level = 1; level < n; level++) {
                const firstValue = permutation[0];
                for (let j = 0; j < level; j++) {
                    permutation[j] = permutation[j + 1];
                }
                permutation[level] = firstValue;

                const nextCount = count[level] + 1;
                if (nextCount <= level) {
                    count[level] = nextCount;
                    break;
                }
                count[level] = 0;
            }
        }
    }

    return { checksum, maxFlips };
}

parentPort.postMessage(run(workerData.n, workerData.start, workerData.end));
`;
async function main() {
    const availableCPUs = typeof os.availableParallelism === "function"
        ? os.availableParallelism()
        : os.cpus().length;
    const workerCount = Math.max(1, Math.min(16, availableCPUs, totalPermutations));
    const jobs = [];
    for (let workerIndex = 0; workerIndex < workerCount; workerIndex++) {
        const start = Math.floor(totalPermutations * workerIndex / workerCount);
        const end = Math.floor(totalPermutations * (workerIndex + 1) / workerCount);
        jobs.push(new Promise((resolve, reject) => {
            const worker = new Worker(workerSource, {
                eval: true,
                workerData: { n, start, end }
            });
            worker.once("message", resolve);
            worker.once("error", reject);
            worker.once("exit", (code) => {
                if (code !== 0) {
                    reject(new Error(`Worker exited with code ${code}`));
                }
            });
        }));
    }
    const results = await Promise.all(jobs);
    let checksum = 0;
    let maxFlips = 0;
    for (const result of results) {
        checksum += result.checksum;
        if (result.maxFlips > maxFlips) {
            maxFlips = result.maxFlips;
        }
    }
    process.stdout.write(`${checksum}\nPfannkuchen(${n}) = ${maxFlips}\n`);
}
main();
