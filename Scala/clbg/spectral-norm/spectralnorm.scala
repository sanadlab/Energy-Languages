/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/
   Based on C# entry by Isaac Gouy, Java by Jarkko Miettinen.
   Scala port translated from the Java reference (single-threaded). */

import java.text.{DecimalFormat, DecimalFormatSymbols}
import java.util.Locale

object spectralnorm {

  private def evalA(i: Int, j: Int): Double = {
    val div = (((i + j) * (i + j + 1)) >>> 1) + i + 1
    1.0 / div
  }

  private def multiplyAv(v: Array[Double], av: Array[Double], n: Int): Unit = {
    var i = 0
    while (i < n) {
      var sum = 0.0
      var j = 0
      while (j < n) { sum += evalA(i, j) * v(j); j += 1 }
      av(i) = sum
      i += 1
    }
  }

  private def multiplyAtv(v: Array[Double], atv: Array[Double], n: Int): Unit = {
    var i = 0
    while (i < n) {
      var sum = 0.0
      var j = 0
      while (j < n) { sum += evalA(j, i) * v(j); j += 1 }
      atv(i) = sum
      i += 1
    }
  }

  private def multiplyAtAv(v: Array[Double], tmp: Array[Double], atav: Array[Double], n: Int): Unit = {
    multiplyAv(v, tmp, n)
    multiplyAtv(tmp, atav, n)
  }

  private def spectralnormGame(n: Int): Double = {
    val u = Array.fill(n)(1.0)
    val v = new Array[Double](n)
    val tmp = new Array[Double](n)
    var i = 0
    while (i < 10) {
      multiplyAtAv(u, tmp, v, n)
      multiplyAtAv(v, tmp, u, n)
      i += 1
    }
    var vBv = 0.0
    var vv = 0.0
    i = 0
    while (i < n) {
      vBv += u(i) * v(i)
      vv += v(i) * v(i)
      i += 1
    }
    math.sqrt(vBv / vv)
  }

  def main(args: Array[String]): Unit = {
    var n = 1000
    if (args.length > 0) n = args(0).toInt
    val fmt = new DecimalFormat("#.000000000", DecimalFormatSymbols.getInstance(Locale.ROOT))
    println(fmt.format(spectralnormGame(n)))
  }
}
