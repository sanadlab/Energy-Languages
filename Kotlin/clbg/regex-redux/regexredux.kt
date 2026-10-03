/*
   The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/

   contributed by Francois Green
   Kotlin port (JVM-to-JVM) of regexredux.java-3.java
*/

import java.io.ByteArrayOutputStream
import java.util.AbstractMap
import java.util.Arrays
import java.util.LinkedHashMap
import java.util.concurrent.CompletableFuture
import java.util.regex.Pattern
import java.util.stream.Collectors

fun main(args: Array<String>) {
    val baos = ByteArrayOutputStream()
    run {
        val buf = ByteArray(65536)
        var count = System.`in`.read(buf)
        while (count > 0) {
            baos.write(buf, 0, count)
            count = System.`in`.read(buf)
        }
    }
    val input = baos.toString("US-ASCII")

    val initialLength = input.length

    val sequence = input.replace(Regex(">.*\n|\n"), "")

    val replacements: CompletableFuture<String> = CompletableFuture.supplyAsync {
        val iub = LinkedHashMap<String, String>()
        iub["tHa[Nt]"] = "<4>"
        iub["aND|caN|Ha[DS]|WaS"] = "<3>"
        iub["a[NSt]|BY"] = "<2>"
        iub["<[^>]*>"] = "|"
        iub["\\|[^|][^|]*\\|"] = "-"

        var buffer = sequence
        for (entry in iub.entries) {
            buffer = Pattern.compile(entry.key).matcher(buffer).replaceAll(entry.value)
        }
        buffer
    }

    val codeLength = sequence.length

    val variants = Arrays.asList(
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

    val results: Map<String, Long> = variants.parallelStream()
        .map { variant ->
            val count = Pattern.compile(variant).splitAsStream(sequence).count() - 1 // Off by one
            AbstractMap.SimpleEntry(variant, count)
        }
        .collect(Collectors.toMap({ it.key }, { it.value }))

    for (variant in variants) {
        println(variant + " " + results[variant])
    }

    println()
    println(initialLength)
    println(codeLength)
    println(replacements.join().length)
}
