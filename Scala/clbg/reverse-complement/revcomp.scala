/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/
   contributed by Leonhard Holz (Java), mapping idea by Anthony Donnefort.
   Scala port translated from the Java reference (single-threaded). */

import java.io.BufferedOutputStream

object revcomp {
  def main(args: Array[String]): Unit = {
    val data = System.in.readAllBytes()
    val n = data.length

    val map = new Array[Byte](256)
    var k = 0
    while (k < 256) { map(k) = k.toByte; k += 1 }
    def put(from: Char, to: Char): Unit = {
      map(from.toLower.toInt) = to.toByte
      map(from.toUpper.toInt) = to.toByte
    }
    put('t', 'A'); put('a', 'T'); put('g', 'C'); put('c', 'G')
    put('v', 'B'); put('h', 'D'); put('r', 'Y'); put('m', 'K')
    put('y', 'R'); put('k', 'M'); put('b', 'V'); put('d', 'H')
    put('u', 'A')

    val NL = '\n'.toByte
    val CR = '\r'.toByte
    val GT = '>'.toByte
    val out = new BufferedOutputStream(System.out, 1 << 16)

    var p = 0
    while (p < n) {
      // header line (starts with '>'): copy verbatim, then its newline
      val hStart = p
      while (p < n && data(p) != NL) p += 1
      out.write(data, hStart, p - hStart)
      out.write(NL.toInt)
      if (p < n) p += 1 // skip the header's newline

      // sequence block runs until the next header or EOF
      val seqStart = p
      while (p < n && data(p) != GT) p += 1
      val blockEnd = p

      // emit the reverse complement, wrapped at 60 columns
      var col = 0
      var j = blockEnd - 1
      while (j >= seqStart) {
        val b = data(j)
        if (b != NL && b != CR) {
          out.write(map(b & 0xff).toInt)
          col += 1
          if (col == 60) { out.write(NL.toInt); col = 0 }
        }
        j -= 1
      }
      if (col > 0) out.write(NL.toInt)
    }
    out.flush()
  }
}
