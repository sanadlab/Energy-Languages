/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * Scala port of the Java program contributed by Mark C. Lewis and
 * others. Single-threaded, same double arithmetic and output format.
 */

import java.util.Locale

object nbody {
  def main(args: Array[String]): Unit = {
    val n = args(0).toInt

    val bodies = new NBodySystem()
    System.out.print(String.format(Locale.US, "%.9f\n", java.lang.Double.valueOf(bodies.energy())))
    var i = 0
    while (i < n) {
      bodies.advance(0.01)
      i += 1
    }
    System.out.print(String.format(Locale.US, "%.9f\n", java.lang.Double.valueOf(bodies.energy())))
  }
}

final class Body {
  var x, y, z, vx, vy, vz, mass: Double = 0.0

  def offsetMomentum(px: Double, py: Double, pz: Double): Body = {
    vx = -px / Body.SOLAR_MASS
    vy = -py / Body.SOLAR_MASS
    vz = -pz / Body.SOLAR_MASS
    this
  }
}

object Body {
  val PI = 3.141592653589793
  val SOLAR_MASS = 4 * PI * PI
  val DAYS_PER_YEAR = 365.24

  def jupiter(): Body = {
    val p = new Body()
    p.x = 4.84143144246472090e+00
    p.y = -1.16032004402742839e+00
    p.z = -1.03622044471123109e-01
    p.vx = 1.66007664274403694e-03 * DAYS_PER_YEAR
    p.vy = 7.69901118419740425e-03 * DAYS_PER_YEAR
    p.vz = -6.90460016972063023e-05 * DAYS_PER_YEAR
    p.mass = 9.54791938424326609e-04 * SOLAR_MASS
    p
  }

  def saturn(): Body = {
    val p = new Body()
    p.x = 8.34336671824457987e+00
    p.y = 4.12479856412430479e+00
    p.z = -4.03523417114321381e-01
    p.vx = -2.76742510726862411e-03 * DAYS_PER_YEAR
    p.vy = 4.99852801234917238e-03 * DAYS_PER_YEAR
    p.vz = 2.30417297573763929e-05 * DAYS_PER_YEAR
    p.mass = 2.85885980666130812e-04 * SOLAR_MASS
    p
  }

  def uranus(): Body = {
    val p = new Body()
    p.x = 1.28943695621391310e+01
    p.y = -1.51111514016986312e+01
    p.z = -2.23307578892655734e-01
    p.vx = 2.96460137564761618e-03 * DAYS_PER_YEAR
    p.vy = 2.37847173959480950e-03 * DAYS_PER_YEAR
    p.vz = -2.96589568540237556e-05 * DAYS_PER_YEAR
    p.mass = 4.36624404335156298e-05 * SOLAR_MASS
    p
  }

  def neptune(): Body = {
    val p = new Body()
    p.x = 1.53796971148509165e+01
    p.y = -2.59193146099879641e+01
    p.z = 1.79258772950371181e-01
    p.vx = 2.68067772490389322e-03 * DAYS_PER_YEAR
    p.vy = 1.62824170038242295e-03 * DAYS_PER_YEAR
    p.vz = -9.51592254519715870e-05 * DAYS_PER_YEAR
    p.mass = 5.15138902046611451e-05 * SOLAR_MASS
    p
  }

  def sun(): Body = {
    val p = new Body()
    p.mass = SOLAR_MASS
    p
  }
}

final class NBodySystem {
  private val LENGTH = 5
  private val bodies: Array[Body] = Array(
    Body.sun(), Body.jupiter(), Body.saturn(), Body.uranus(), Body.neptune()
  )

  {
    var px = 0.0
    var py = 0.0
    var pz = 0.0
    var i = 0
    while (i < LENGTH) {
      px += bodies(i).vx * bodies(i).mass
      py += bodies(i).vy * bodies(i).mass
      pz += bodies(i).vz * bodies(i).mass
      i += 1
    }
    bodies(0).offsetMomentum(px, py, pz)
  }

  def advance(dt: Double): Unit = {
    val b = bodies
    var i = 0
    while (i < LENGTH - 1) {
      val iBody = b(i)
      val iMass = iBody.mass
      val ix = iBody.x; val iy = iBody.y; val iz = iBody.z

      var j = i + 1
      while (j < LENGTH) {
        val jBody = b(j)
        val dx = ix - jBody.x
        val dy = iy - jBody.y
        val dz = iz - jBody.z

        val dSquared = dx * dx + dy * dy + dz * dz
        val distance = Math.sqrt(dSquared)
        val mag = dt / (dSquared * distance)

        val jMass = jBody.mass

        iBody.vx -= dx * jMass * mag
        iBody.vy -= dy * jMass * mag
        iBody.vz -= dz * jMass * mag

        jBody.vx += dx * iMass * mag
        jBody.vy += dy * iMass * mag
        jBody.vz += dz * iMass * mag

        j += 1
      }
      i += 1
    }

    i = 0
    while (i < LENGTH) {
      val body = b(i)
      body.x += dt * body.vx
      body.y += dt * body.vy
      body.z += dt * body.vz
      i += 1
    }
  }

  def energy(): Double = {
    var e = 0.0
    var i = 0
    while (i < bodies.length) {
      val iBody = bodies(i)
      e += 0.5 * iBody.mass *
        (iBody.vx * iBody.vx + iBody.vy * iBody.vy + iBody.vz * iBody.vz)

      var j = i + 1
      while (j < bodies.length) {
        val jBody = bodies(j)
        val dx = iBody.x - jBody.x
        val dy = iBody.y - jBody.y
        val dz = iBody.z - jBody.z

        val distance = Math.sqrt(dx * dx + dy * dy + dz * dz)
        e -= (iBody.mass * jBody.mass) / distance
        j += 1
      }
      i += 1
    }
    e
  }
}
