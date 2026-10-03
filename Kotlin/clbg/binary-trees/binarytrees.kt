/**
 * The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * based on Jarkko Miettinen's Java program
 * contributed by Tristan Dupont
 * Kotlin port (JVM-to-JVM) of binarytrees.java-7.java
 */

import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

private const val MIN_DEPTH = 4

private class TreeNode(private val left: TreeNode?, private val right: TreeNode?) {

    constructor() : this(null, null)

    fun itemCheck(): Int {
        // if necessary deallocate here
        if (left == null) {
            return 1
        }
        return 1 + left.itemCheck() + right!!.itemCheck()
    }
}

private fun bottomUpTree(depth: Int): TreeNode {
    if (0 < depth) {
        return TreeNode(bottomUpTree(depth - 1), bottomUpTree(depth - 1))
    }
    return TreeNode()
}

fun main(args: Array<String>) {
    var n = 0
    if (0 < args.size) {
        n = args[0].toInt()
    }

    val maxDepth = if (n < MIN_DEPTH + 2) MIN_DEPTH + 2 else n
    val stretchDepth = maxDepth + 1

    println("stretch tree of depth " + stretchDepth + "\t check: " +
        bottomUpTree(stretchDepth).itemCheck())

    val longLivedTree = bottomUpTree(maxDepth)

    val results = arrayOfNulls<String>((maxDepth - MIN_DEPTH) / 2 + 1)

    val executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors())

    var d = MIN_DEPTH
    while (d <= maxDepth) {
        val depth = d
        executorService.execute {
            var check = 0

            val iterations = 1 shl (maxDepth - depth + MIN_DEPTH)
            for (i in 1..iterations) {
                val treeNode1 = bottomUpTree(depth)
                check += treeNode1.itemCheck()
            }
            results[(depth - MIN_DEPTH) / 2] =
                iterations.toString() + "\t trees of depth " + depth + "\t check: " + check
        }
        d += 2
    }

    executorService.shutdown()
    executorService.awaitTermination(120L, TimeUnit.SECONDS)

    for (str in results) {
        println(str)
    }

    println("long lived tree of depth " + maxDepth +
        "\t check: " + longLivedTree.itemCheck())
}
