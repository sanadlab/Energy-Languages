import java.util.Locale;

public class nbody {
    private static final double SOLAR_MASS = 4.0 * Math.PI * Math.PI;
    private static final double DAYS_PER_YEAR = 365.24;
    private static final double DT = 0.01;

    private static final class Body {
        double x, y, z;
        double vx, vy, vz;
        final double mass;

        Body(double x, double y, double z,
             double vx, double vy, double vz, double mass) {
            this.x = x;
            this.y = y;
            this.z = z;
            this.vx = vx * DAYS_PER_YEAR;
            this.vy = vy * DAYS_PER_YEAR;
            this.vz = vz * DAYS_PER_YEAR;
            this.mass = mass * SOLAR_MASS;
        }
    }

    private static Body[] createSystem() {
        return new Body[] {
            new Body(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0),
            new Body(
                4.84143144246472090,
                -1.16032004402742839,
                -1.03622044471123109e-1,
                1.66007664274403694e-3,
                7.69901118419740425e-3,
                -6.90460016972063023e-5,
                9.54791938424326609e-4
            ),
            new Body(
                8.34336671824457987,
                4.12479856412430479,
                -4.03523417114321381e-1,
                -2.76742510726862411e-3,
                4.99852801234917238e-3,
                2.30417297573763929e-5,
                2.85885980666130812e-4
            ),
            new Body(
                1.28943695621391310e1,
                -1.51111514016986312e1,
                -2.23307578892655734e-1,
                2.96460137564761618e-3,
                2.37847173959480950e-3,
                -2.96589568540237556e-5,
                4.36624404335156298e-5
            ),
            new Body(
                1.53796971148509165e1,
                -2.59193146099879641e1,
                1.79258772950371181e-1,
                2.68067772490389322e-3,
                1.62824170038242295e-3,
                -9.51592254519715870e-5,
                5.15138902046611451e-5
            )
        };
    }

    private static void offsetMomentum(Body[] bodies) {
        double px = 0.0;
        double py = 0.0;
        double pz = 0.0;

        for (Body b : bodies) {
            px += b.vx * b.mass;
            py += b.vy * b.mass;
            pz += b.vz * b.mass;
        }

        bodies[0].vx = -px / SOLAR_MASS;
        bodies[0].vy = -py / SOLAR_MASS;
        bodies[0].vz = -pz / SOLAR_MASS;
    }

    private static double energy(Body[] bodies) {
        double result = 0.0;

        for (int i = 0; i < bodies.length; i++) {
            Body a = bodies[i];
            result += 0.5 * a.mass
                    * (a.vx * a.vx + a.vy * a.vy + a.vz * a.vz);

            for (int j = i + 1; j < bodies.length; j++) {
                Body b = bodies[j];
                double dx = a.x - b.x;
                double dy = a.y - b.y;
                double dz = a.z - b.z;
                double distance = Math.sqrt(dx * dx + dy * dy + dz * dz);
                result -= (a.mass * b.mass) / distance;
            }
        }

        return result;
    }

    private static void advance(Body[] bodies, int steps) {
        final int count = bodies.length;

        for (int step = 0; step < steps; step++) {
            for (int i = 0; i < count - 1; i++) {
                Body a = bodies[i];
                double ax = a.x;
                double ay = a.y;
                double az = a.z;
                double avx = a.vx;
                double avy = a.vy;
                double avz = a.vz;
                double amass = a.mass;

                for (int j = i + 1; j < count; j++) {
                    Body b = bodies[j];
                    double dx = ax - b.x;
                    double dy = ay - b.y;
                    double dz = az - b.z;
                    double distanceSquared = dx * dx + dy * dy + dz * dz;
                    double magnitude = DT
                            / (distanceSquared * Math.sqrt(distanceSquared));

                    avx -= dx * b.mass * magnitude;
                    avy -= dy * b.mass * magnitude;
                    avz -= dz * b.mass * magnitude;

                    b.vx += dx * amass * magnitude;
                    b.vy += dy * amass * magnitude;
                    b.vz += dz * amass * magnitude;
                }

                a.vx = avx;
                a.vy = avy;
                a.vz = avz;
            }

            for (int i = 0; i < count; i++) {
                Body b = bodies[i];
                b.x += DT * b.vx;
                b.y += DT * b.vy;
                b.z += DT * b.vz;
            }
        }
    }

    public static void main(String[] args) {
        int n = Integer.parseInt(args[0]);
        Body[] bodies = createSystem();
        offsetMomentum(bodies);

        double initialEnergy = energy(bodies);
        advance(bodies, n);
        double finalEnergy = energy(bodies);

        System.out.printf(Locale.ROOT, "%.9f\n%.9f\n",
                          initialEnergy, finalEnergy);
    }
}