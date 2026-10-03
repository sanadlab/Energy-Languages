/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * Scala port of the C++ program ("fasta C++ g++ #5"), single
 * threaded. The pseudo-random generator and the cumulative
 * probabilities use the same float arithmetic as the C++ source so
 * the generated nucleotides match byte-for-byte.
 */

import java.io.BufferedOutputStream
import java.io.OutputStream

object fasta {

  private val alu =
    "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
    "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
    "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
    "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
    "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
    "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
    "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

  private val iubChars  = "acgtBDHKMNRSVWY".getBytes("US-ASCII")
  private val iubProbs  = Array(
    0.27f, 0.12f, 0.12f, 0.27f, 0.02f, 0.02f, 0.02f, 0.02f,
    0.02f, 0.02f, 0.02f, 0.02f, 0.02f, 0.02f, 0.02f)

  private val homoChars = "acgt".getBytes("US-ASCII")
  private val homoProbs = Array(
    0.3029549426680f, 0.1979883004921f, 0.1975473066391f, 0.3015094502008f)

  private val IM = 139968
  private val IA = 3877
  private val IC = 29573
  private val IM_RECIPROCAL = 1.0f / IM
  private var last = 42

  private val LINE = 60

  private def genRandom(): Int = {
    last = (last * IA + IC) % IM
    last
  }

  // Running float partial sum, matching std::partial_sum on the IUB p field.
  private def makeCumulative(p: Array[Float]): Array[Float] = {
    val c = new Array[Float](p.length)
    var sum = 0.0f
    var i = 0
    while (i < p.length) {
      sum += p(i)
      c(i) = sum
      i += 1
    }
    c
  }

  private def writeRepeat(out: OutputStream, header: String, seq: Array[Byte], count: Int): Unit = {
    out.write(header.getBytes("US-ASCII"))
    var idx = 0
    var col = 0
    var i = 0
    while (i < count) {
      out.write(seq(idx))
      idx += 1
      if (idx == seq.length) idx = 0
      col += 1
      if (col == LINE) { out.write('\n'); col = 0 }
      i += 1
    }
    if (col != 0) out.write('\n')
  }

  private def writeRandom(out: OutputStream, header: String, chars: Array[Byte],
                          cum: Array[Float], count: Int): Unit = {
    out.write(header.getBytes("US-ASCII"))
    var col = 0
    var i = 0
    while (i < count) {
      val p: Float = genRandom() * IM_RECIPROCAL
      var k = 0
      while (k < cum.length - 1 && cum(k) < p) k += 1
      out.write(chars(k))
      col += 1
      if (col == LINE) { out.write('\n'); col = 0 }
      i += 1
    }
    if (col != 0) out.write('\n')
  }

  def main(args: Array[String]): Unit = {
    val n = args(0).toInt

    val iubCum = makeCumulative(iubProbs)
    val homoCum = makeCumulative(homoProbs)

    val out: OutputStream = new BufferedOutputStream(System.out)

    writeRepeat(out, ">ONE Homo sapiens alu\n", alu.getBytes("US-ASCII"), n * 2)
    writeRandom(out, ">TWO IUB ambiguity codes\n", iubChars, iubCum, n * 3)
    writeRandom(out, ">THREE Homo sapiens frequency\n", homoChars, homoCum, n * 5)

    out.close()
  }
}
