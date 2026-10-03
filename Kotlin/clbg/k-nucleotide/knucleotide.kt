/* The Computer Language Benchmarks Game
 http://benchmarksgame.alioth.debian.org/

 contributed by James McIlree
 modified by Tagir Valeev

 Kotlin port (JVM-to-JVM) of knucleotide.java
 */

import java.io.BufferedReader
import java.io.InputStream
import java.io.InputStreamReader
import java.nio.charset.StandardCharsets
import java.util.ArrayList
import java.util.Locale
import java.util.concurrent.Callable
import java.util.concurrent.Executors
import java.util.concurrent.Future

private val codes = byteArrayOf(-1, 0, -1, 1, 3, -1, -1, 2)
private val nucleotides = charArrayOf('A', 'C', 'G', 'T')

private class Result(val keyLength: Int) {
    val map = Long2IntOpenHashMap()
}

private fun createFragmentTasks(sequence: ByteArray, fragmentLengths: IntArray): ArrayList<Callable<Result>> {
    val tasks = ArrayList<Callable<Result>>()
    for (fragmentLength in fragmentLengths) {
        for (index in 0 until fragmentLength) {
            val offset = index
            tasks.add(Callable { createFragmentMap(sequence, offset, fragmentLength) })
        }
    }
    return tasks
}

private fun createFragmentMap(sequence: ByteArray, offset: Int, fragmentLength: Int): Result {
    val res = Result(fragmentLength)
    val map = res.map
    val lastIndex = sequence.size - fragmentLength + 1
    var index = offset
    while (index < lastIndex) {
        map.addTo(getKey(sequence, index, fragmentLength), 1)
        index += fragmentLength
    }
    return res
}

private fun sumTwoMaps(map1: Result, map2: Result): Result {
    map2.map.forEach { key, value -> map1.map.addTo(key, value) }
    return map1
}

private fun writeFrequencies(totalCount: Float, frequencies: Result): String {
    val freq = ArrayList<Pair<String, Int>>(frequencies.map.size())
    frequencies.map.forEach { key, cnt ->
        freq.add(Pair(keyToString(key, frequencies.keyLength), cnt))
    }
    freq.sortByDescending { it.second }
    val sb = StringBuilder()
    for (entry in freq) {
        sb.append(String.format(Locale.ENGLISH, "%s %.3f\n", entry.first,
            entry.second * 100.0f / totalCount))
    }
    return sb.append('\n').toString()
}

private fun writeCount(futures: List<Future<Result>>, nucleotideFragment: String): String {
    val key = toCodes(nucleotideFragment.toByteArray(StandardCharsets.ISO_8859_1),
        nucleotideFragment.length)
    val k = getKey(key, 0, nucleotideFragment.length)
    var count = 0
    for (future in futures) {
        val f = future.get()
        if (f.keyLength == nucleotideFragment.length) {
            count += f.map.get(k)
        }
    }

    return count.toString() + "\t" + nucleotideFragment + '\n'
}

/**
 * Convert long key to the nucleotides string
 */
private fun keyToString(key: Long, length: Int): String {
    var k = key
    val res = CharArray(length)
    for (i in 0 until length) {
        res[length - i - 1] = nucleotides[(k and 0x3L).toInt()]
        k = k shr 2
    }
    return String(res)
}

/**
 * Get the long key for given byte array of codes at given offset and length
 * (length must be less than 32)
 */
private fun getKey(arr: ByteArray, offset: Int, length: Int): Long {
    var key = 0L
    for (i in offset until offset + length) {
        key = key * 4 + arr[i]
    }
    return key
}

/**
 * Convert given byte array (limiting to given length) containing acgtACGT
 * to codes (0 = A, 1 = C, 2 = G, 3 = T) and returns new array
 */
private fun toCodes(sequence: ByteArray, length: Int): ByteArray {
    val result = ByteArray(length)
    for (i in 0 until length) {
        result[i] = codes[sequence[i].toInt() and 0x7]
    }
    return result
}

private fun read(stream: InputStream): ByteArray {
    var line: String?
    val input = BufferedReader(InputStreamReader(stream, StandardCharsets.ISO_8859_1))
    while (true) {
        line = input.readLine()
        if (line == null) break
        if (line.startsWith(">THREE")) break
    }

    var bytes = ByteArray(1048576)
    var position = 0
    while (true) {
        line = input.readLine()
        if (line == null || line[0] == '>') break
        if (line.length + position > bytes.size) {
            val newBytes = ByteArray(bytes.size * 2)
            System.arraycopy(bytes, 0, newBytes, 0, position)
            bytes = newBytes
        }
        for (i in 0 until line.length) {
            bytes[position++] = line[i].code.toByte()
        }
    }

    return toCodes(bytes, position)
}

fun main(args: Array<String>) {
    val sequence = read(System.`in`)

    val pool = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors())
    val fragmentLengths = intArrayOf(1, 2, 3, 4, 6, 12, 18)
    val futures: List<Future<Result>> = pool.invokeAll(createFragmentTasks(sequence, fragmentLengths))
    pool.shutdown()

    val sb = StringBuilder()

    sb.append(writeFrequencies(sequence.size.toFloat(), futures[0].get()))
    sb.append(writeFrequencies((sequence.size - 1).toFloat(),
        sumTwoMaps(futures[1].get(), futures[2].get())))

    val nucleotideFragments = arrayOf("GGT", "GGTA", "GGTATT", "GGTATTTTAATT",
        "GGTATTTTAATTTATAGT")
    for (nucleotideFragment in nucleotideFragments) {
        sb.append(writeCount(futures, nucleotideFragment))
    }

    print(sb)
}

private class Long2IntOpenHashMap {
    private val delegate = HashMap<Long, Int>()

    fun addTo(key: Long, value: Int) {
        delegate[key] = delegate.getOrDefault(key, 0) + value
    }

    fun get(key: Long): Int {
        return delegate.getOrDefault(key, 0)
    }

    fun size(): Int {
        return delegate.size
    }

    fun forEach(consumer: (Long, Int) -> Unit) {
        for (entry in delegate.entries) {
            consumer(entry.key, entry.value)
        }
    }
}
