const N = parseInt(process.argv[2] ?? "0", 10);
const PI = 3.141592653589793;
const SOLAR_MASS = 4.0 * PI * PI;
const DAYS_PER_YEAR = 365.24;
const px = new Float64Array(5);
const py = new Float64Array(5);
const pz = new Float64Array(5);
const vx = new Float64Array(5);
const vy = new Float64Array(5);
const vz = new Float64Array(5);
const mass = new Float64Array(5);
function offsetMomentum() {
    let pxm = 0.0, pym = 0.0, pzm = 0.0;
    for (let i = 0; i < 5; i++) {
        pxm += vx[i] * mass[i];
        pym += vy[i] * mass[i];
        pzm += vz[i] * mass[i];
    }
    vx[0] = -pxm / SOLAR_MASS;
    vy[0] = -pym / SOLAR_MASS;
    vz[0] = -pzm / SOLAR_MASS;
}
function initBodies() {
    // Sun
    px[0] = 0;
    py[0] = 0;
    pz[0] = 0;
    vx[0] = 0;
    vy[0] = 0;
    vz[0] = 0;
    mass[0] = SOLAR_MASS;
    // Jupiter
    px[1] = 4.84143144246472090e+00;
    py[1] = -1.16032004402742839e+00;
    pz[1] = -1.03622044471123109e-01;
    vx[1] = 1.66007664274403694e-03 * DAYS_PER_YEAR;
    vy[1] = 7.69901118419740425e-03 * DAYS_PER_YEAR;
    vz[1] = -6.90460016972063023e-05 * DAYS_PER_YEAR;
    mass[1] = 9.54791938424326609e-04 * SOLAR_MASS;
    // Saturn
    px[2] = 8.34336671824457987e+00;
    py[2] = 4.12479856412430479e+00;
    pz[2] = -4.03523417114321381e-01;
    vx[2] = -2.76742510726862411e-03 * DAYS_PER_YEAR;
    vy[2] = 4.99852801234917238e-03 * DAYS_PER_YEAR;
    vz[2] = 2.30417297573763929e-05 * DAYS_PER_YEAR;
    mass[2] = 2.85885980666130812e-04 * SOLAR_MASS;
    // Uranus
    px[3] = 1.28943695621391310e+01;
    py[3] = -1.51111514016986312e+01;
    pz[3] = -2.23307578892655734e-01;
    vx[3] = 2.96460137564761618e-03 * DAYS_PER_YEAR;
    vy[3] = 2.37847173959480950e-03 * DAYS_PER_YEAR;
    vz[3] = -2.96589568540237556e-05 * DAYS_PER_YEAR;
    mass[3] = 4.36624404335156298e-05 * SOLAR_MASS;
    // Neptune
    px[4] = 1.53796971148509165e+01;
    py[4] = -2.59193146099879641e+01;
    pz[4] = 1.79258772950371181e-01;
    vx[4] = 2.68067772490389322e-03 * DAYS_PER_YEAR;
    vy[4] = 1.62824170038242295e-03 * DAYS_PER_YEAR;
    vz[4] = -9.51592254519715870e-05 * DAYS_PER_YEAR;
    mass[4] = 5.15138902046611451e-05 * SOLAR_MASS;
    offsetMomentum();
}
function energy() {
    let e = 0.0;
    for (let i = 0; i < 5; i++) {
        const m = mass[i];
        e += 0.5 * m * (vx[i] * vx[i] + vy[i] * vy[i] + vz[i] * vz[i]);
        for (let j = i + 1; j < 5; j++) {
            const dx = px[i] - px[j];
            const dy = py[i] - py[j];
            const dz = pz[i] - pz[j];
            const dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
            e -= (m * mass[j]) / dist;
        }
    }
    return e;
}
function advance(dt) {
    for (let i = 0; i < 5; i++) {
        for (let j = i + 1; j < 5; j++) {
            const dx = px[i] - px[j];
            const dy = py[i] - py[j];
            const dz = pz[i] - pz[j];
            const d2 = dx * dx + dy * dy + dz * dz;
            const dist = Math.sqrt(d2);
            const mag = dt / (d2 * dist);
            const mi = mass[i];
            const mj = mass[j];
            const s1 = mj * mag;
            const s2 = mi * mag;
            vx[i] -= dx * s1;
            vy[i] -= dy * s1;
            vz[i] -= dz * s1;
            vx[j] += dx * s2;
            vy[j] += dy * s2;
            vz[j] += dz * s2;
        }
    }
    for (let i = 0; i < 5; i++) {
        px[i] += dt * vx[i];
        py[i] += dt * vy[i];
        pz[i] += dt * vz[i];
    }
}
initBodies();
const initial = energy();
for (let i = 0; i < N; i++)
    advance(0.01);
const final = energy();
process.stdout.write(initial.toFixed(9) + "\n" + final.toFixed(9) + "\n");
