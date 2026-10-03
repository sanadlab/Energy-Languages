/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/
   contributed by Mike Pall, java port by Stefan Krause
   Scala port translated from the Java reference. */

import java.math.BigInteger

object pidigits {
  private var q = BigInteger.ONE
  private var r = BigInteger.ZERO
  private var s = BigInteger.ZERO
  private var t = BigInteger.ONE
  private var u = BigInteger.ZERO
  private var v = BigInteger.ZERO
  private var w = BigInteger.ZERO

  private var i = 0
  private var n = 0
  private var strBuf = new StringBuilder(20)

  private def bi(x: Int): BigInteger = BigInteger.valueOf(x.toLong)

  private def composeR(bq: Int, br: Int, bs: Int, bt: Int): Unit = {
    u = r.multiply(bi(bs))
    r = r.multiply(bi(bq))
    v = t.multiply(bi(br))
    r = r.add(v)
    t = t.multiply(bi(bt))
    t = t.add(u)
    s = s.multiply(bi(bt))
    u = q.multiply(bi(bs))
    s = s.add(u)
    q = q.multiply(bi(bq))
  }

  private def composeL(bq: Int, br: Int, bs: Int, bt: Int): Unit = {
    r = r.multiply(bi(bt))
    u = q.multiply(bi(br))
    r = r.add(u)
    u = t.multiply(bi(bs))
    t = t.multiply(bi(bt))
    v = s.multiply(bi(br))
    t = t.add(v)
    s = s.multiply(bi(bq))
    s = s.add(u)
    q = q.multiply(bi(bq))
  }

  private def extract(j: Int): Int = {
    u = q.multiply(bi(j))
    u = u.add(r)
    v = s.multiply(bi(j))
    v = v.add(t)
    w = u.divide(v)
    w.intValue()
  }

  private def prdigit(y: Int): Boolean = {
    strBuf.append(y)
    i += 1
    if (i % 10 == 0 || i == n) {
      if (i % 10 != 0) {
        var jj = 10 - (i % 10)
        while (jj > 0) { strBuf.append(" "); jj -= 1 }
      }
      strBuf.append("\t:")
      strBuf.append(i)
      println(strBuf.toString)
      strBuf = new StringBuilder(20)
    }
    i == n
  }

  private def run(): Unit = {
    var k = 1
    i = 0
    q = bi(1); r = bi(0); s = bi(0); t = bi(1)
    var loop = true
    while (loop) {
      val y = extract(3)
      if (y == extract(4)) {
        if (prdigit(y)) loop = false
        else composeR(10, -10 * y, 0, 1)
      } else {
        composeL(k, 4 * k + 2, 0, 2 * k + 1)
        k += 1
      }
    }
  }

  def main(args: Array[String]): Unit = {
    n = args(0).toInt
    run()
  }
}
