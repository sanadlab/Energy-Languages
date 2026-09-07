import java.util.Locale;

class nbody {
    private static final double PI = 3.141592653589793;
    private static final double SOLAR_MASS = 4.0 * PI * PI;
    private static final double DAYS_PER_YEAR = 365.24;
    private static final double DT = 0.01;

    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);

        double[] x = {
            0.0,
            4.84143144246472090e+00,
            8.34336671824457987e+00,
            1.28943695621391310e+01,
            1.53796971148509165e+01
        };

        double[] y = {
            0.0,
            -1.16032004402742839e+00,
            4.12479856412430479e+00,
            -1.51111514016986312e+01,
            -2.59193146099879641e+01
        };

        double[] z = {
            0.0,
            -1.03622044471123109e-01,
            -4.03523417114321381e-01,
            -2.23307578892655734e-01,
            1.79258772950371181e-01
        };

        double[] vx = {
            0.0,
            1.66007664274403694e-03 * DAYS_PER_YEAR,
            -2.76742510726862411e-03 * DAYS_PER_YEAR,
            2.96460137564761618e-03 * DAYS_PER_YEAR,
            2.68067772490389322e-03 * DAYS_PER_YEAR
        };

        double[] vy = {
            0.0,
            7.69901118419740425e-03 * DAYS_PER_YEAR,
            4.99852801234917238e-03 * DAYS_PER_YEAR,
            2.37847173959480950e-03 * DAYS_PER_YEAR,
            1.62824170038242295e-03 * DAYS_PER_YEAR
        };

        double[] vz = {
            0.0,
            -6.90460016972063023e-05 * DAYS_PER_YEAR,
            2.30417297573763929e-05 * DAYS_PER_YEAR,
            -2.96589568540237556e-05 * DAYS_PER_YEAR,
            -9.51592254519715870e-05 * DAYS_PER_YEAR
        };

        double[] mass = {
            SOLAR_MASS,
            9.54791938424326609e-04 * SOLAR_MASS,
            2.85885980666130812e-04 * SOLAR_MASS,
            4.36624404335156298e-05 * SOLAR_MASS,
            5.15138902046611451e-05 * SOLAR_MASS
        };

        offsetMomentum(vx, vy, vz, mass);

        double initialEnergy = energy(x, y, z, vx, vy, vz, mass);
        advance(n, x, y, z, vx, vy, vz, mass);
        double finalEnergy = energy(x, y, z, vx, vy, vz, mass);

        Locale.setDefault(Locale.US);
        System.out.printf("%.9f%n%.9f%n", initialEnergy, finalEnergy);
    }

    private static void offsetMomentum(double[] vx, double[] vy, double[] vz,
                                       double[] mass) {
        double px = 0.0;
        double py = 0.0;
        double pz = 0.0;

        for (int i = 0; i < 5; i++) {
            px += vx[i] * mass[i];
            py += vy[i] * mass[i];
            pz += vz[i] * mass[i];
        }

        vx[0] = -px / SOLAR_MASS;
        vy[0] = -py / SOLAR_MASS;
        vz[0] = -pz / SOLAR_MASS;
    }

    private static double energy(double[] x, double[] y, double[] z,
                                 double[] vx, double[] vy, double[] vz,
                                 double[] mass) {
        double e = 0.0;

        for (int i = 0; i < 5; i++) {
            e += 0.5 * mass[i]
                * (vx[i] * vx[i] + vy[i] * vy[i] + vz[i] * vz[i]);

            for (int j = i + 1; j < 5; j++) {
                double dx = x[i] - x[j];
                double dy = y[i] - y[j];
                double dz = z[i] - z[j];
                double distance = Math.sqrt(dx * dx + dy * dy + dz * dz);
                e -= mass[i] * mass[j] / distance;
            }
        }

        return e;
    }

    private static void advance(int steps,
                                double[] x, double[] y, double[] z,
                                double[] vx, double[] vy, double[] vz,
                                double[] mass) {
        double x0 = x[0], x1 = x[1], x2 = x[2], x3 = x[3], x4 = x[4];
        double y0 = y[0], y1 = y[1], y2 = y[2], y3 = y[3], y4 = y[4];
        double z0 = z[0], z1 = z[1], z2 = z[2], z3 = z[3], z4 = z[4];

        double vx0 = vx[0], vx1 = vx[1], vx2 = vx[2], vx3 = vx[3], vx4 = vx[4];
        double vy0 = vy[0], vy1 = vy[1], vy2 = vy[2], vy3 = vy[3], vy4 = vy[4];
        double vz0 = vz[0], vz1 = vz[1], vz2 = vz[2], vz3 = vz[3], vz4 = vz[4];

        double m0 = mass[0], m1 = mass[1], m2 = mass[2], m3 = mass[3], m4 = mass[4];

        for (int step = 0; step < steps; step++) {
            double dx, dy, dz, d2, mag;

            dx = x0 - x1;
            dy = y0 - y1;
            dz = z0 - z1;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx0 -= dx * m1 * mag;
            vy0 -= dy * m1 * mag;
            vz0 -= dz * m1 * mag;
            vx1 += dx * m0 * mag;
            vy1 += dy * m0 * mag;
            vz1 += dz * m0 * mag;

            dx = x0 - x2;
            dy = y0 - y2;
            dz = z0 - z2;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx0 -= dx * m2 * mag;
            vy0 -= dy * m2 * mag;
            vz0 -= dz * m2 * mag;
            vx2 += dx * m0 * mag;
            vy2 += dy * m0 * mag;
            vz2 += dz * m0 * mag;

            dx = x0 - x3;
            dy = y0 - y3;
            dz = z0 - z3;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx0 -= dx * m3 * mag;
            vy0 -= dy * m3 * mag;
            vz0 -= dz * m3 * mag;
            vx3 += dx * m0 * mag;
            vy3 += dy * m0 * mag;
            vz3 += dz * m0 * mag;

            dx = x0 - x4;
            dy = y0 - y4;
            dz = z0 - z4;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx0 -= dx * m4 * mag;
            vy0 -= dy * m4 * mag;
            vz0 -= dz * m4 * mag;
            vx4 += dx * m0 * mag;
            vy4 += dy * m0 * mag;
            vz4 += dz * m0 * mag;

            dx = x1 - x2;
            dy = y1 - y2;
            dz = z1 - z2;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx1 -= dx * m2 * mag;
            vy1 -= dy * m2 * mag;
            vz1 -= dz * m2 * mag;
            vx2 += dx * m1 * mag;
            vy2 += dy * m1 * mag;
            vz2 += dz * m1 * mag;

            dx = x1 - x3;
            dy = y1 - y3;
            dz = z1 - z3;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx1 -= dx * m3 * mag;
            vy1 -= dy * m3 * mag;
            vz1 -= dz * m3 * mag;
            vx3 += dx * m1 * mag;
            vy3 += dy * m1 * mag;
            vz3 += dz * m1 * mag;

            dx = x1 - x4;
            dy = y1 - y4;
            dz = z1 - z4;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx1 -= dx * m4 * mag;
            vy1 -= dy * m4 * mag;
            vz1 -= dz * m4 * mag;
            vx4 += dx * m1 * mag;
            vy4 += dy * m1 * mag;
            vz4 += dz * m1 * mag;

            dx = x2 - x3;
            dy = y2 - y3;
            dz = z2 - z3;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx2 -= dx * m3 * mag;
            vy2 -= dy * m3 * mag;
            vz2 -= dz * m3 * mag;
            vx3 += dx * m2 * mag;
            vy3 += dy * m2 * mag;
            vz3 += dz * m2 * mag;

            dx = x2 - x4;
            dy = y2 - y4;
            dz = z2 - z4;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx2 -= dx * m4 * mag;
            vy2 -= dy * m4 * mag;
            vz2 -= dz * m4 * mag;
            vx4 += dx * m2 * mag;
            vy4 += dy * m2 * mag;
            vz4 += dz * m2 * mag;

            dx = x3 - x4;
            dy = y3 - y4;
            dz = z3 - z4;
            d2 = dx * dx + dy * dy + dz * dz;
            mag = DT / (d2 * Math.sqrt(d2));
            vx3 -= dx * m4 * mag;
            vy3 -= dy * m4 * mag;
            vz3 -= dz * m4 * mag;
            vx4 += dx * m3 * mag;
            vy4 += dy * m3 * mag;
            vz4 += dz * m3 * mag;

            x0 += DT * vx0;
            y0 += DT * vy0;
            z0 += DT * vz0;

            x1 += DT * vx1;
            y1 += DT * vy1;
            z1 += DT * vz1;

            x2 += DT * vx2;
            y2 += DT * vy2;
            z2 += DT * vz2;

            x3 += DT * vx3;
            y3 += DT * vy3;
            z3 += DT * vz3;

            x4 += DT * vx4;
            y4 += DT * vy4;
            z4 += DT * vz4;
        }

        x[0] = x0; x[1] = x1; x[2] = x2; x[3] = x3; x[4] = x4;
        y[0] = y0; y[1] = y1; y[2] = y2; y[3] = y3; y[4] = y4;
        z[0] = z0; z[1] = z1; z[2] = z2; z[3] = z3; z[4] = z4;

        vx[0] = vx0; vx[1] = vx1; vx[2] = vx2; vx[3] = vx3; vx[4] = vx4;
        vy[0] = vy0; vy[1] = vy1; vy[2] = vy2; vy[3] = vy3; vy[4] = vy4;
        vz[0] = vz0; vz[1] = vz1; vz[2] = vz2; vz[3] = vz3; vz[4] = vz4;
    }
}