const n = Number.parseInt(process.argv[2], 10);
function multiplyA(input, output) {
    let i = 0;
    for (; i + 3 < n; i += 4) {
        const triangular = i * (i + 1) * 0.5;
        let d0 = triangular + i + 1;
        let d1 = d0 + i + 2;
        let d2 = d1 + i + 3;
        let d3 = d2 + i + 4;
        let s0 = 0.0;
        let s1 = 0.0;
        let s2 = 0.0;
        let s3 = 0.0;
        for (let j = 0; j < n; j++) {
            const value = input[j];
            s0 += value / d0;
            s1 += value / d1;
            s2 += value / d2;
            s3 += value / d3;
            const increment = i + j + 1;
            d0 += increment;
            d1 += increment + 1;
            d2 += increment + 2;
            d3 += increment + 3;
        }
        output[i] = s0;
        output[i + 1] = s1;
        output[i + 2] = s2;
        output[i + 3] = s3;
    }
    for (; i < n; i++) {
        let denominator = i * (i + 1) * 0.5 + i + 1;
        let sum = 0.0;
        for (let j = 0; j < n; j++) {
            sum += input[j] / denominator;
            denominator += i + j + 1;
        }
        output[i] = sum;
    }
}
function multiplyAt(input, output) {
    let i = 0;
    for (; i + 3 < n; i += 4) {
        const triangular = i * (i + 1) * 0.5;
        let d0 = triangular + 1;
        let d1 = d0 + i + 1;
        let d2 = d1 + i + 2;
        let d3 = d2 + i + 3;
        let s0 = 0.0;
        let s1 = 0.0;
        let s2 = 0.0;
        let s3 = 0.0;
        for (let j = 0; j < n; j++) {
            const value = input[j];
            s0 += value / d0;
            s1 += value / d1;
            s2 += value / d2;
            s3 += value / d3;
            const increment = i + j + 2;
            d0 += increment;
            d1 += increment + 1;
            d2 += increment + 2;
            d3 += increment + 3;
        }
        output[i] = s0;
        output[i + 1] = s1;
        output[i + 2] = s2;
        output[i + 3] = s3;
    }
    for (; i < n; i++) {
        let denominator = i * (i + 1) * 0.5 + 1;
        let sum = 0.0;
        for (let j = 0; j < n; j++) {
            sum += input[j] / denominator;
            denominator += i + j + 2;
        }
        output[i] = sum;
    }
}
function multiplyAtA(input, output, temporary) {
    multiplyA(input, temporary);
    multiplyAt(temporary, output);
}
const u = new Float64Array(n);
const v = new Float64Array(n);
const temporary = new Float64Array(n);
u.fill(1.0);
for (let iteration = 0; iteration < 10; iteration++) {
    multiplyAtA(u, v, temporary);
    multiplyAtA(v, u, temporary);
}
let uv = 0.0;
let vv = 0.0;
for (let i = 0; i < n; i++) {
    uv += u[i] * v[i];
    vv += v[i] * v[i];
}
console.log(Math.sqrt(uv / vv).toFixed(9));
