import sys
from math import sqrt

PI = 3.141592653589793
SOLAR_MASS = 4 * PI * PI
DAYS_PER_YEAR = 365.24


def offset_momentum(px, py, pz, bodies):
    sun = bodies[0]
    sun[3] = -px / SOLAR_MASS
    sun[4] = -py / SOLAR_MASS
    sun[5] = -pz / SOLAR_MASS


def energy(bodies):
    e = 0.0
    nb = len(bodies)
    for i in range(nb):
        bi = bodies[i]
        m1 = bi[6]
        e += 0.5 * m1 * (bi[3] * bi[3] + bi[4] * bi[4] + bi[5] * bi[5])
        for j in range(i + 1, nb):
            bj = bodies[j]
            dx = bi[0] - bj[0]
            dy = bi[1] - bj[1]
            dz = bi[2] - bj[2]
            dist = sqrt(dx * dx + dy * dy + dz * dz)
            e -= (m1 * bj[6]) / dist
    return e


def advance(bodies, dt, n):
    for _ in range(n):
        # Update velocities
        for i in range(len(bodies)):
            bi = bodies[i]
            xi, yi, zi, vxi, vyi, vzi, mi = bi
            for j in range(i + 1, len(bodies)):
                bj = bodies[j]
                dx = xi - bj[0]
                dy = yi - bj[1]
                dz = zi - bj[2]
                dist2 = dx * dx + dy * dy + dz * dz
                dist = sqrt(dist2)
                mag = dt / (dist2 * dist)
                mj = bj[6]
                bi[3] -= dx * mj * mag
                bi[4] -= dy * mj * mag
                bi[5] -= dz * mj * mag
                bj[3] += dx * mi * mag
                bj[4] += dy * mi * mag
                bj[5] += dz * mi * mag

        # Update positions
        for b in bodies:
            b[0] += dt * b[3]
            b[1] += dt * b[4]
            b[2] += dt * b[5]


def main():
    n = int(sys.argv[1])

    bodies = [
        [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS],
        [4.84143144246472090e+00, -1.16032004402742839e+00, -1.03622044471123109e-01,
         1.66007664274403694e-03 * DAYS_PER_YEAR,
         7.69901118419740425e-03 * DAYS_PER_YEAR,
         -6.90460016972063023e-05 * DAYS_PER_YEAR,
         9.54791938424326609e-04 * SOLAR_MASS],
        [8.34336671824457987e+00, 4.12479856412430479e+00, -4.03523417114321381e-01,
         -2.76742510726862411e-03 * DAYS_PER_YEAR,
         4.99852801234917238e-03 * DAYS_PER_YEAR,
         2.30417297573763929e-05 * DAYS_PER_YEAR,
         2.85885980666130812e-04 * SOLAR_MASS],
        [1.28943695621391310e+01, -1.51111514016986312e+01, -2.23307578892655734e-01,
         2.96460137564761618e-03 * DAYS_PER_YEAR,
         2.37847173959480950e-03 * DAYS_PER_YEAR,
         -2.96589568540237556e-05 * DAYS_PER_YEAR,
         4.36624404335156298e-05 * SOLAR_MASS],
        [1.53796971148509165e+01, -2.59193146099879641e+01, 1.79258772950371181e-01,
         2.68067772490389322e-03 * DAYS_PER_YEAR,
         1.62824170038242295e-03 * DAYS_PER_YEAR,
         -9.51592254519715870e-05 * DAYS_PER_YEAR,
         5.15138902046611451e-05 * SOLAR_MASS],
    ]

    px = py = pz = 0.0
    for b in bodies:
        m = b[6]
        px += b[3] * m
        py += b[4] * m
        pz += b[5] * m
    offset_momentum(px, py, pz, bodies)

    print(f"{energy(bodies):.9f}")
    advance(bodies, 0.01, n)
    print(f"{energy(bodies):.9f}")


if __name__ == "__main__":
    main()