/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/

   contributed by Leonhard Holz
   thanks to Anthony Donnefort for the basic mapping idea
   Kotlin port (JVM-to-JVM) of revcomp.java-3.java
*/

import java.util.ArrayList
import java.util.Collections
import java.util.LinkedList
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

private const val CHUNK_SIZE = 1024 * 1024 * 16
private val NUMBER_OF_CORES = Runtime.getRuntime().availableProcessors()
private val service: ExecutorService = Executors.newFixedThreadPool(NUMBER_OF_CORES)
private val list: MutableList<ByteArray> = Collections.synchronizedList(ArrayList<ByteArray>())

private val map: ByteArray = ByteArray(256).also { m ->
    for (i in m.indices) {
        m[i] = i.toByte()
    }
    m['t'.code] = 'A'.code.toByte(); m['T'.code] = 'A'.code.toByte()
    m['a'.code] = 'T'.code.toByte(); m['A'.code] = 'T'.code.toByte()
    m['g'.code] = 'C'.code.toByte(); m['G'.code] = 'C'.code.toByte()
    m['c'.code] = 'G'.code.toByte(); m['C'.code] = 'G'.code.toByte()
    m['v'.code] = 'B'.code.toByte(); m['V'.code] = 'B'.code.toByte()
    m['h'.code] = 'D'.code.toByte(); m['H'.code] = 'D'.code.toByte()
    m['r'.code] = 'Y'.code.toByte(); m['R'.code] = 'Y'.code.toByte()
    m['m'.code] = 'K'.code.toByte(); m['M'.code] = 'K'.code.toByte()
    m['y'.code] = 'R'.code.toByte(); m['Y'.code] = 'R'.code.toByte()
    m['k'.code] = 'M'.code.toByte(); m['K'.code] = 'M'.code.toByte()
    m['b'.code] = 'V'.code.toByte(); m['B'.code] = 'V'.code.toByte()
    m['d'.code] = 'H'.code.toByte(); m['D'.code] = 'H'.code.toByte()
    m['u'.code] = 'A'.code.toByte(); m['U'.code] = 'A'.code.toByte()
}

fun main(args: Array<String>) {
    var read: Int
    var buffer: ByteArray
    var lastFinder: Finder? = null

    do {
        buffer = ByteArray(CHUNK_SIZE)
        read = System.`in`.read(buffer)
        list.add(buffer)

        val finder = Finder(buffer, read, lastFinder)
        service.execute(finder)
        lastFinder = finder
    } while (read == CHUNK_SIZE)

    val status = lastFinder!!.finish()
    val mapper = Mapper(status.lastFinding, status.count - 1, status.lastMapper)
    service.execute(mapper)

    service.shutdown()
}

private class Status {
    var count = 0
    var lastFinding = 0
    var lastMapper: Mapper? = null
}

private class Finder(
    private val a: ByteArray,
    private val size: Int,
    private val previous: Finder?
) : Runnable {

    private var status: Status? = null
    @Volatile private var done = false

    fun finish(): Status {
        while (!done) {
            try {
                Thread.sleep(1)
            } catch (e: InterruptedException) {
                // ignored
            }
        }
        return status!!
    }

    override fun run() {
        val findings = LinkedList<Int>()

        for (i in 0 until size) {
            if (a[i] == '>'.code.toByte()) {
                findings.add(i)
            }
        }

        val st: Status
        if (previous == null) {
            st = Status()
        } else {
            st = previous.finish()
            findings.add(0, st.lastFinding)
            for (i in 1 until findings.size) {
                findings[i] = findings[i] + st.count
            }
        }
        status = st

        if (findings.size > 1) {
            for (i in 0 until findings.size - 1) {
                val mapper = Mapper(findings[i], findings[i + 1] - 1, st.lastMapper)
                st.lastMapper = mapper
                service.execute(mapper)
            }
        }

        st.lastFinding = findings[findings.size - 1]
        st.count += size
        done = true
    }
}

private class Mapper(
    private val start: Int,
    private val end: Int,
    private val previous: Mapper?
) : Runnable {

    @Volatile private var done = false

    fun finish() {
        while (!done) {
            try {
                Thread.sleep(1)
            } catch (e: InterruptedException) {
                // ignored
            }
        }
    }

    override fun run() {
        val positions = find(list, start, end)

        var lp1 = positions[0]
        var tob = list[lp1]

        var lp2 = positions[2]
        var bot = list[lp2]

        var p1 = positions[1]
        while (tob[p1] != '\n'.code.toByte()) p1++

        var p2 = positions[3]

        while (lp1 < lp2 || p1 < p2) {
            if (tob[p1] == '\n'.code.toByte()) {
                p1++
            } else if (bot[p2] == '\n'.code.toByte()) {
                p2--
            } else {
                val tmp = tob[p1]
                tob[p1] = map[bot[p2].toInt() and 0xff]
                bot[p2] = map[tmp.toInt() and 0xff]
                p1++
                p2--
            }
            if (p1 == tob.size) {
                lp1++
                tob = list[lp1]
                p1 = 0
            }
            if (p2 == -1) {
                lp2--
                bot = list[lp2]
                p2 = bot.size - 1
            }
        }

        if (previous != null) {
            previous.finish()
        }

        write(list, positions[0], positions[1], positions[2], positions[3])
        done = true
    }
}

private fun write(list: List<ByteArray>, lpStart: Int, start: Int, lpEnd: Int, end: Int) {
    var lp = lpStart
    var st = start
    var a = list[lp]
    while (lp < lpEnd) {
        System.out.write(a, st, a.size - st)
        lp++
        a = list[lp]
        st = 0
    }
    System.out.write(a, st, end - st + 1)
}

private fun find(list: List<ByteArray>, start: Int, end: Int): IntArray {
    var n = 0
    var lp = 0
    val result = IntArray(4)
    var foundStart = false

    for (bytes in list) {
        if (!foundStart && n + bytes.size > start) {
            result[0] = lp
            result[1] = start - n
            foundStart = true
        }
        if (foundStart && n + bytes.size > end) {
            result[2] = lp
            result[3] = end - n
            break
        }
        n += bytes.size
        lp++
    }
    return result
}
