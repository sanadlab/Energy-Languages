"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const worker_threads_1 = require("worker_threads");
const os = require("os");
function createRealCoordinates(n) {
    const real = new Float64Array(n);
    const scale = 2.0 / n;
    for (let x = 0; x < n; x++) {
        real[x] = x * scale - 1.5;
    }
    return real;
}
function renderRows(n, pixels, real, firstRow, lastRow) {
    const bytesPerRow = (n + 7) >> 3;
    const scale = 2.0 / n;
    for (let y = firstRow; y < lastRow; y++) {
        const ci = y * scale - 1.0;
        const ci2 = ci * ci;
        const rowOffset = y * bytesPerRow;
        let x = 0;
        for (let byteIndex = 0; byteIndex < bytesPerRow; byteIndex++) {
            let value = 0;
            for (let bit = 0; bit < 8 && x < n; bit++, x++) {
                const cr = real[x];
                let inside = false;
                const shifted = cr - 0.25;
                const q = shifted * shifted + ci2;
                if (q * (q + shifted) <= 0.25 * ci2 ||
                    (cr + 1.0) * (cr + 1.0) + ci2 <= 0.0625) {
                    inside = true;
                }
                else {
                    let zr = 0.0;
                    let zi = 0.0;
                    let zr2 = 0.0;
                    let zi2 = 0.0;
                    inside = true;
                    for (let iteration = 0; iteration < 50; iteration++) {
                        zi = 2.0 * zr * zi + ci;
                        zr = zr2 - zi2 + cr;
                        zr2 = zr * zr;
                        zi2 = zi * zi;
                        if (zr2 + zi2 > 4.0) {
                            inside = false;
                            break;
                        }
                    }
                }
                if (inside) {
                    value |= 0x80 >> bit;
                }
            }
            pixels[rowOffset + byteIndex] = value;
        }
    }
}
function runWorker() {
    const data = worker_threads_1.workerData;
    const pixels = new Uint8Array(data.pixelsBuffer);
    const counter = new Int32Array(data.counterBuffer);
    const real = createRealCoordinates(data.n);
    const rowsPerTask = 2;
    while (true) {
        const firstRow = Atomics.add(counter, 0, rowsPerTask);
        if (firstRow >= data.n) {
            break;
        }
        renderRows(data.n, pixels, real, firstRow, Math.min(firstRow + rowsPerTask, data.n));
    }
    worker_threads_1.parentPort.postMessage(0);
}
async function main() {
    const n = Number.parseInt(process.argv[2], 10);
    const bytesPerRow = (n + 7) >> 3;
    const pixelsBuffer = new SharedArrayBuffer(bytesPerRow * n);
    const pixels = new Uint8Array(pixelsBuffer);
    const availableParallelism = typeof os.availableParallelism === "function"
        ? os.availableParallelism()
        : os.cpus().length;
    if (n < 800 || availableParallelism <= 1) {
        renderRows(n, pixels, createRealCoordinates(n), 0, n);
    }
    else {
        const counterBuffer = new SharedArrayBuffer(Int32Array.BYTES_PER_ELEMENT);
        const workerCount = Math.min(availableParallelism, 32, n);
        const workers = [];
        for (let i = 0; i < workerCount; i++) {
            workers.push(new Promise((resolve, reject) => {
                const worker = new worker_threads_1.Worker(__filename, {
                    workerData: {
                        n,
                        pixelsBuffer,
                        counterBuffer
                    }
                });
                worker.once("message", () => resolve());
                worker.once("error", reject);
                worker.once("exit", code => {
                    if (code !== 0) {
                        reject(new Error(`Worker exited with code ${code}`));
                    }
                });
            }));
        }
        await Promise.all(workers);
    }
    process.stdout.write(`P4\n${n} ${n}\n`);
    process.stdout.write(Buffer.from(pixelsBuffer));
}
if (worker_threads_1.isMainThread) {
    void main();
}
else {
    runWorker();
}
