/* The Computer Language Benchmarks Game
 * https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 *
 * Based on the C++ program contributed by Dave Compton
 * ("fannkuch-redux C++ g++ #5"). Scala port, single-threaded: the
 * blocks are iterated sequentially, which gives the same checksum
 * and maxFlips because both reductions (sum, max) are order
 * independent.
 */

object fannkuchredux {

  private val fact = new Array[Long](32)

  private def initializeFact(n: Int): Unit = {
    fact(0) = 1
    var i = 1
    while (i <= n) {
      fact(i) = i * fact(i - 1)
      i += 1
    }
  }

  private final class Permutation(n: Int, start0: Long) {
    private val count = new Array[Int](n)
    private val current = new Array[Byte](n)

    {
      // Initialize count.
      var start = start0
      var i = n - 1
      while (i >= 0) {
        val d = (start / fact(i)).toInt
        start = start % fact(i)
        count(i) = d
        i -= 1
      }

      // Initialize current to the identity permutation.
      i = 0
      while (i < n) {
        current(i) = i.toByte
        i += 1
      }

      // Apply the rotations recorded in count.
      i = n - 1
      while (i >= 0) {
        rotateLeft(current, i + 1, count(i))
        i -= 1
      }
    }

    // std::rotate(first, first+d, first+len): left-rotate current[0, len) by d.
    private def rotateLeft(a: Array[Byte], len: Int, d: Int): Unit = {
      if (len <= 0 || d == 0) return
      val tmp = new Array[Byte](len)
      var k = 0
      while (k < len) {
        tmp(k) = a((k + d) % len)
        k += 1
      }
      k = 0
      while (k < len) {
        a(k) = tmp(k)
        k += 1
      }
    }

    def advance(): Unit = {
      var i = 1
      var done = false
      while (!done) {
        val first = current(0)
        var j = 0
        while (j < i) {
          current(j) = current(j + 1)
          j += 1
        }
        current(i) = first

        count(i) += 1
        if (count(i) <= i) done = true
        else {
          count(i) = 0
          i += 1
        }
      }
    }

    def countFlips(): Long = {
      val len = current.length
      var flips = 0L
      var first = current(0).toInt
      if (first > 0) {
        flips = 1
        val temp = new Array[Byte](len)
        var i = 0
        while (i < len) {
          temp(i) = current(i)
          i += 1
        }

        while (temp(first) > 0) {
          val newFirst = temp(first).toInt
          temp(first) = first.toByte

          if (first > 2) {
            var low = 1
            var high = first - 1
            var brk = false
            while (!brk) {
              val t = temp(low); temp(low) = temp(high); temp(high) = t
              if (!(low + 3 <= high && low < 16)) brk = true
              else { low += 1; high -= 1 }
            }
          }
          first = newFirst
          flips += 1
        }
      }
      flips
    }
  }

  def main(args: Array[String]): Unit = {
    val n = args(0).toInt

    initializeFact(n)

    var blockCount = 24L
    if (blockCount > fact(n)) blockCount = 1
    val blockLength = fact(n) / blockCount

    var maxFlips = 0L
    var checksum = 0L

    var blockStart = 0L
    while (blockStart < fact(n)) {
      val permutation = new Permutation(n, blockStart)
      var index = blockStart
      var done = false
      while (!done) {
        val flips = permutation.countFlips()
        if (flips != 0) {
          if (index % 2 == 0) checksum += flips
          else checksum -= flips
          if (flips > maxFlips) maxFlips = flips
        }
        index += 1
        if (index == blockStart + blockLength) done = true
        else permutation.advance()
      }
      blockStart += blockLength
    }

    println(checksum)
    println("Pfannkuchen(" + n + ") = " + maxFlips)
  }
}
