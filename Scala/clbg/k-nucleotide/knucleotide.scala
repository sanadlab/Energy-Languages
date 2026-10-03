/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * Scala port of the Java program contributed by James McIlree and
 * Tagir Valeev, single threaded. Reads a FASTA stream on stdin,
 * takes the sequence after ">THREE", and reports k-mer frequencies
 * and counts. A java.util.HashMap plus a stable sort reproduce the
 * Java output order exactly.
 */

import java.io.{BufferedReader, InputStream, InputStreamReader}
import java.nio.charset.StandardCharsets
import java.util.Locale
import scala.collection.mutable.ArrayBuffer

object knucleotide {
  private val codes = Array[Byte](-1, 0, -1, 1, 3, -1, -1, 2)
  private val nucleotides = Array('A', 'C', 'G', 'T')

  private def getKey(arr: Array[Byte], offset: Int, length: Int): Long = {
    var key = 0L
    var i = offset
    val end = offset + length
    while (i < end) {
      key = key * 4 + arr(i)
      i += 1
    }
    key
  }

  private def keyToString(key0: Long, length: Int): String = {
    val res = new Array[Char](length)
    var key = key0
    var i = 0
    while (i < length) {
      res(length - i - 1) = nucleotides((key & 0x3L).toInt)
      key >>= 2
      i += 1
    }
    new String(res)
  }

  // Count every L-mer at every position (sliding window, step 1). This is the
  // union of the Java per-offset fragment maps for a given fragment length.
  private def buildMap(seq: Array[Byte], length: Int): java.util.HashMap[java.lang.Long, Integer] = {
    val map = new java.util.HashMap[java.lang.Long, Integer]()
    val lastIndex = seq.length - length + 1
    var index = 0
    while (index < lastIndex) {
      val k = java.lang.Long.valueOf(getKey(seq, index, length))
      val cur = map.get(k)
      map.put(k, if (cur == null) Integer.valueOf(1) else Integer.valueOf(cur.intValue + 1))
      index += 1
    }
    map
  }

  private def writeFrequencies(totalCount: Float, map: java.util.HashMap[java.lang.Long, Integer],
                               keyLength: Int): String = {
    val freq = new ArrayBuffer[(String, Int)](map.size)
    val it = map.entrySet().iterator()
    while (it.hasNext) {
      val e = it.next()
      freq += ((keyToString(e.getKey.longValue, keyLength), e.getValue.intValue))
    }
    val sorted = freq.sortBy(e => -e._2) // stable: ties keep HashMap iteration order
    val sb = new StringBuilder
    for ((key, cnt) <- sorted) {
      sb.append(String.format(Locale.ENGLISH, "%s %.3f\n", key,
        java.lang.Float.valueOf(cnt * 100.0f / totalCount)))
    }
    sb.append('\n').toString
  }

  private def fragmentKey(fragment: String): Long = {
    var key = 0L
    var i = 0
    while (i < fragment.length) {
      key = key * 4 + codes(fragment.charAt(i).toInt & 0x7)
      i += 1
    }
    key
  }

  private def writeCount(seq: Array[Byte], fragment: String): String = {
    val map = buildMap(seq, fragment.length)
    val k = java.lang.Long.valueOf(fragmentKey(fragment))
    val cur = map.get(k)
    val count = if (cur == null) 0 else cur.intValue
    count + "\t" + fragment + "\n"
  }

  private def read(is: InputStream): Array[Byte] = {
    val in = new BufferedReader(new InputStreamReader(is, StandardCharsets.ISO_8859_1))
    var line = in.readLine()
    while (line != null && !line.startsWith(">THREE")) line = in.readLine()

    val seq = ArrayBuffer[Byte]()
    line = in.readLine()
    while (line != null && (line.isEmpty || line.charAt(0) != '>')) {
      var i = 0
      while (i < line.length) {
        seq += codes(line.charAt(i).toInt & 0x7)
        i += 1
      }
      line = in.readLine()
    }
    seq.toArray
  }

  def main(args: Array[String]): Unit = {
    val sequence = read(System.in)

    val sb = new StringBuilder
    sb.append(writeFrequencies(sequence.length.toFloat, buildMap(sequence, 1), 1))
    sb.append(writeFrequencies((sequence.length - 1).toFloat, buildMap(sequence, 2), 2))

    val fragments = Array("GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT")
    var i = 0
    while (i < fragments.length) {
      sb.append(writeCount(sequence, fragments(i)))
      i += 1
    }

    System.out.print(sb)
  }
}
