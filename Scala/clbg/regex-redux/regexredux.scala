/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/
   contributed by Francois Green (Java).
   Scala port translated from the Java reference (single-threaded). */

import java.util.regex.Pattern
import java.nio.charset.StandardCharsets

object regexredux {
  def main(args: Array[String]): Unit = {
    val bytes = System.in.readAllBytes()
    val input = new String(bytes, StandardCharsets.US_ASCII)

    val initialLength = input.length
    val sequence = input.replaceAll(">.*\n|\n", "")
    val codeLength = sequence.length

    val variants = Array(
      "agggtaaa|tttaccct",
      "[cgt]gggtaaa|tttaccc[acg]",
      "a[act]ggtaaa|tttacc[agt]t",
      "ag[act]gtaaa|tttac[agt]ct",
      "agg[act]taaa|ttta[agt]cct",
      "aggg[acg]aaa|ttt[cgt]ccct",
      "agggt[cgt]aa|tt[acg]accct",
      "agggta[cgt]a|t[acg]taccct",
      "agggtaa[cgt]|[acg]ttaccct"
    )

    val sb = new StringBuilder
    for (v <- variants) {
      val count = Pattern.compile(v).splitAsStream(sequence).count() - 1
      sb.append(v).append(' ').append(count).append('\n')
    }

    val iub = Array(
      ("tHa[Nt]", "<4>"),
      ("aND|caN|Ha[DS]|WaS", "<3>"),
      ("a[NSt]|BY", "<2>"),
      ("<[^>]*>", "|"),
      ("\\|[^|][^|]*\\|", "-")
    )
    var buffer = sequence
    for ((k, repl) <- iub) {
      buffer = Pattern.compile(k).matcher(buffer).replaceAll(repl)
    }

    sb.append('\n')
    sb.append(initialLength).append('\n')
    sb.append(codeLength).append('\n')
    sb.append(buffer.length).append('\n')

    print(sb.toString)
  }
}
