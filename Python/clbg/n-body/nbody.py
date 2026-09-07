import sys
from math import pi, sqrt


SOLAR_MASS = 4.0 * pi * pi
DAYS_PER_YEAR = 365.24
DT = 0.01


def initial_state():
    masses = [
        SOLAR_MASS,
        9.54791938424326609e-4 * SOLAR_MASS,
        2.85885980666130812e-4 * SOLAR_MASS,
        4.36624404335156298e-5 * SOLAR_MASS,
        5.15138902046611451e-5 * SOLAR_MASS,
    ]

    x = [
        0.0,
        4.84143144246472090,
        8.34336671824457987,
        12.8943695621391310,
        15.3796971148509165,
    ]
    y = [
        0.0,
        -1.16032004402742839,
        4.12479856412430479,
        -15.1111514016986312,
        -25.9193146099879641,
    ]
    z = [
        0.0,
        -0.103622044471123109,
        -0.403523417114321381,
        -0.223307578892655734,
        0.179258772950371181,
    ]

    vx = [
        0.0,
        1.66007664274403694e-3 * DAYS_PER_YEAR,
        -2.76742510726862411e-3 * DAYS_PER_YEAR,
        2.96460137564761618e-3 * DAYS_PER_YEAR,
        2.68067772490389322e-3 * DAYS_PER_YEAR,
    ]
    vy = [
        0.0,
        7.69901118419740425e-3 * DAYS_PER_YEAR,
        4.99852801234917238e-3 * DAYS_PER_YEAR,
        2.37847173959480950e-3 * DAYS_PER_YEAR,
        1.62824170038242295e-3 * DAYS_PER_YEAR,
    ]
    vz = [
        0.0,
        -6.90460016972063023e-5 * DAYS_PER_YEAR,
        2.30417297573763929e-5 * DAYS_PER_YEAR,
        -2.96589568540237556e-5 * DAYS_PER_YEAR,
        -9.51592254519715870e-5 * DAYS_PER_YEAR,
    ]

    px = py = pz = 0.0
    for i in range(1, 5):
        mass = masses[i]
        px += vx[i] * mass
        py += vy[i] * mass
        pz += vz[i] * mass

    vx[0] = -px / SOLAR_MASS
    vy[0] = -py / SOLAR_MASS
    vz[0] = -pz / SOLAR_MASS

    return x, y, z, vx, vy, vz, masses


def energy(x, y, z, vx, vy, vz, masses):
    total = 0.0

    for i in range(5):
        total += 0.5 * masses[i] * (
            vx[i] * vx[i] + vy[i] * vy[i] + vz[i] * vz[i]
        )

        for j in range(i + 1, 5):
            dx = x[i] - x[j]
            dy = y[i] - y[j]
            dz = z[i] - z[j]
            total -= masses[i] * masses[j] / sqrt(
                dx * dx + dy * dy + dz * dz
            )

    return total


def advance(n, x, y, z, vx, vy, vz, masses):
    x0, x1, x2, x3, x4 = x
    y0, y1, y2, y3, y4 = y
    z0, z1, z2, z3, z4 = z
    vx0, vx1, vx2, vx3, vx4 = vx
    vy0, vy1, vy2, vy3, vy4 = vy
    vz0, vz1, vz2, vz3, vz4 = vz
    m0, m1, m2, m3, m4 = masses

    d0 = DT * m0
    d1 = DT * m1
    d2 = DT * m2
    d3 = DT * m3
    d4 = DT * m4

    root = sqrt

    for _ in range(n):
        dx = x0 - x1
        dy = y0 - y1
        dz = z0 - z1
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d1 * inv
        b = d0 * inv
        vx0 -= dx * a
        vy0 -= dy * a
        vz0 -= dz * a
        vx1 += dx * b
        vy1 += dy * b
        vz1 += dz * b

        dx = x0 - x2
        dy = y0 - y2
        dz = z0 - z2
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d2 * inv
        b = d0 * inv
        vx0 -= dx * a
        vy0 -= dy * a
        vz0 -= dz * a
        vx2 += dx * b
        vy2 += dy * b
        vz2 += dz * b

        dx = x0 - x3
        dy = y0 - y3
        dz = z0 - z3
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d3 * inv
        b = d0 * inv
        vx0 -= dx * a
        vy0 -= dy * a
        vz0 -= dz * a
        vx3 += dx * b
        vy3 += dy * b
        vz3 += dz * b

        dx = x0 - x4
        dy = y0 - y4
        dz = z0 - z4
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d4 * inv
        b = d0 * inv
        vx0 -= dx * a
        vy0 -= dy * a
        vz0 -= dz * a
        vx4 += dx * b
        vy4 += dy * b
        vz4 += dz * b

        dx = x1 - x2
        dy = y1 - y2
        dz = z1 - z2
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d2 * inv
        b = d1 * inv
        vx1 -= dx * a
        vy1 -= dy * a
        vz1 -= dz * a
        vx2 += dx * b
        vy2 += dy * b
        vz2 += dz * b

        dx = x1 - x3
        dy = y1 - y3
        dz = z1 - z3
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d3 * inv
        b = d1 * inv
        vx1 -= dx * a
        vy1 -= dy * a
        vz1 -= dz * a
        vx3 += dx * b
        vy3 += dy * b
        vz3 += dz * b

        dx = x1 - x4
        dy = y1 - y4
        dz = z1 - z4
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d4 * inv
        b = d1 * inv
        vx1 -= dx * a
        vy1 -= dy * a
        vz1 -= dz * a
        vx4 += dx * b
        vy4 += dy * b
        vz4 += dz * b

        dx = x2 - x3
        dy = y2 - y3
        dz = z2 - z3
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d3 * inv
        b = d2 * inv
        vx2 -= dx * a
        vy2 -= dy * a
        vz2 -= dz * a
        vx3 += dx * b
        vy3 += dy * b
        vz3 += dz * b

        dx = x2 - x4
        dy = y2 - y4
        dz = z2 - z4
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d4 * inv
        b = d2 * inv
        vx2 -= dx * a
        vy2 -= dy * a
        vz2 -= dz * a
        vx4 += dx * b
        vy4 += dy * b
        vz4 += dz * b

        dx = x3 - x4
        dy = y3 - y4
        dz = z3 - z4
        r2 = dx * dx + dy * dy + dz * dz
        inv = 1.0 / (r2 * root(r2))
        a = d4 * inv
        b = d3 * inv
        vx3 -= dx * a
        vy3 -= dy * a
        vz3 -= dz * a
        vx4 += dx * b
        vy4 += dy * b
        vz4 += dz * b

        x0 += DT * vx0
        y0 += DT * vy0
        z0 += DT * vz0
        x1 += DT * vx1
        y1 += DT * vy1
        z1 += DT * vz1
        x2 += DT * vx2
        y2 += DT * vy2
        z2 += DT * vz2
        x3 += DT * vx3
        y3 += DT * vy3
        z3 += DT * vz3
        x4 += DT * vx4
        y4 += DT * vy4
        z4 += DT * vz4

    x[:] = x0, x1, x2, x3, x4
    y[:] = y0, y1, y2, y3, y4
    z[:] = z0, z1, z2, z3, z4
    vx[:] = vx0, vx1, vx2, vx3, vx4
    vy[:] = vy0, vy1, vy2, vy3, vy4
    vz[:] = vz0, vz1, vz2, vz3, vz4


def main():
    n = int(sys.argv[1])
    x, y, z, vx, vy, vz, masses = initial_state()

    print(f"{energy(x, y, z, vx, vy, vz, masses):.9f}")
    advance(n, x, y, z, vx, vy, vz, masses)
    print(f"{energy(x, y, z, vx, vy, vz, masses):.9f}")


if __name__ == "__main__":
    main()