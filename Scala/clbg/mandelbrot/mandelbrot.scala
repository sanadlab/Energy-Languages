/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * Scala port of the Java program ("mandelbrot Java #2"), single
 * threaded. Writes a binary PBM (P4) image to stdout. The N <= 200
 * path mirrors the Java simpleMandelbrot used for the reference
 * image at the validation size.
 */

import java.io.BufferedOutputStream
import java.io.OutputStream

object mandelbrot {

  private var out: Array[Array[Byte]] = _
  private var Crb: Array[Double] = _
  private var Cib: Array[Double] = _

  private def getByte(x: Int, y: Int): Int = {
    var res = 0
    var i = 0
    while (i < 8) {
      var Zr1 = Crb(x + i)
      var Zi1 = Cib(y)
      var Zr2 = Crb(x + i + 1)
      var Zi2 = Cib(y)

      var b = 0
      var j = 49
      var break = false
      while (!break) {
        val nZr1 = Zr1 * Zr1 - Zi1 * Zi1 + Crb(x + i)
        val nZi1 = Zr1 * Zi1 + Zr1 * Zi1 + Cib(y)
        Zr1 = nZr1; Zi1 = nZi1

        val nZr2 = Zr2 * Zr2 - Zi2 * Zi2 + Crb(x + i + 1)
        val nZi2 = Zr2 * Zi2 + Zr2 * Zi2 + Cib(y)
        Zr2 = nZr2; Zi2 = nZi2

        if (Zr1 * Zr1 + Zi1 * Zi1 > 4) { b |= 2; if (b == 3) break = true }
        if (!break && Zr2 * Zr2 + Zi2 * Zi2 > 4) { b |= 1; if (b == 3) break = true }

        if (!break) { j -= 1; if (j <= 0) break = true }
      }
      res = (res << 2) + b
      i += 2
    }
    res ^ -1
  }

  private def putLine(y: Int, line: Array[Byte]): Unit = {
    var xb = 0
    while (xb < line.length) {
      line(xb) = getByte(xb * 8, y).toByte
      xb += 1
    }
  }

  def main(args: Array[String]): Unit = {
    var N = 6000
    if (args.length >= 1) N = args(0).toInt
    if (N <= 200) {
      simpleMandelbrot(N)
      return
    }

    Crb = new Array[Double](N + 7)
    Cib = new Array[Double](N + 7)
    val invN = 2.0 / N
    var i = 0
    while (i < N) {
      Cib(i) = i * invN - 1.0
      Crb(i) = i * invN - 1.5
      i += 1
    }
    out = Array.ofDim[Byte](N, (N + 7) / 8)

    var y = 0
    while (y < out.length) {
      putLine(y, out(y))
      y += 1
    }

    val stream: OutputStream = new BufferedOutputStream(System.out)
    stream.write(("P4\n" + N + " " + N + "\n").getBytes("US-ASCII"))
    i = 0
    while (i < N) {
      stream.write(out(i))
      i += 1
    }
    stream.close()
  }

  private def simpleMandelbrot(n: Int): Unit = {
    val stream: OutputStream = new BufferedOutputStream(System.out)
    stream.write(("P4\n" + n + " " + n + "\n").getBytes("US-ASCII"))
    val c1 = 2.0 / n
    var y = 0
    while (y < n) {
      val row = new Array[Byte]((n + 7) / 8)
      val ci = y * c1 - 1.0
      var xByte = 0
      while (xByte < row.length) {
        var bits = 0
        var bit = 0
        while (bit < 8) {
          val x = xByte * 8 + bit
          if (x < n && simplePixel(x * c1 - 1.5, ci)) {
            bits |= 128 >> bit
          }
          bit += 1
        }
        row(xByte) = bits.toByte
        xByte += 1
      }
      if (n % 8 != 0) {
        row(row.length - 1) = (row(row.length - 1) & (0xff << (8 - n % 8))).toByte
      }
      stream.write(row)
      y += 1
    }
    stream.close()
  }

  private def simplePixel(cr: Double, ci: Double): Boolean = {
    var zr = cr
    var zi = ci
    var outer = 0
    while (outer < 7) {
      var inner = 0
      while (inner < 7) {
        val nzr = zr * zr - zi * zi + cr
        zi = zr * zi + zr * zi + ci
        zr = nzr
        inner += 1
      }
      if (zr * zr + zi * zi >= 4.0) return false
      outer += 1
    }
    true
  }
}
