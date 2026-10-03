/* The Computer Language Benchmarks Game
 * https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
 *
 * Contributed by Jon Harrop
 * Modified by Alex Mizrahi
 * Scala port (single-threaded) of the C++ binary-trees program.
 */

object binarytrees {

  final class Node(val l: Node, val r: Node) {
    def check(): Int =
      if (l != null) l.check() + 1 + r.check()
      else 1
  }

  def make(d: Int): Node =
    if (d == 0) new Node(null, null)
    else new Node(make(d - 1), make(d - 1))

  def main(args: Array[String]): Unit = {
    val minDepth = 4
    val maxDepth = math.max(minDepth + 2, if (args.length == 1) args(0).toInt else 10)
    val stretchDepth = maxDepth + 1

    {
      val c = make(stretchDepth)
      println("stretch tree of depth " + stretchDepth + "\t check: " + c.check())
    }

    val longLivedTree = make(maxDepth)

    var d = minDepth
    while (d <= maxDepth) {
      val iterations = 1 << (maxDepth - d + minDepth)
      var c = 0
      var i = 1
      while (i <= iterations) {
        val a = make(d)
        c += a.check()
        i += 1
      }
      println(iterations + "\t trees of depth " + d + "\t check: " + c)
      d += 2
    }

    println("long lived tree of depth " + maxDepth + "\t check: " + longLivedTree.check())
  }
}
