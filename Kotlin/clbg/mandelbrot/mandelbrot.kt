/* The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * contributed by Stefan Krause
 * slightly modified by Chad Whipkey
 * parallelized by Colin D Bennett 2008-10-04
 * reduce synchronization cost by The Anh Tran
 * optimizations and refactoring by Enotus 2010-11-11
 * optimization by John Stalcup 2012-2-19
 *
 * Kotlin port (JVM-to-JVM) of mandelbrot.java-2.java
 */

import java.io.BufferedOutputStream
import java.io.OutputStream
import java.util.concurrent.atomic.AtomicInteger

private lateinit var out: Array<ByteArray>
private lateinit var yCt: AtomicInteger
private lateinit var Crb: DoubleArray
private lateinit var Cib: DoubleArray

private fun getByte(x: Int, y: Int): Int {
    var res = 0
    var i = 0
    while (i < 8) {
        var Zr1 = Crb[x + i]
        var Zi1 = Cib[y]

        var Zr2 = Crb[x + i + 1]
        var Zi2 = Cib[y]

        var b = 0
        var j = 49
        do {
            val nZr1 = Zr1 * Zr1 - Zi1 * Zi1 + Crb[x + i]
            val nZi1 = Zr1 * Zi1 + Zr1 * Zi1 + Cib[y]
            Zr1 = nZr1
            Zi1 = nZi1

            val nZr2 = Zr2 * Zr2 - Zi2 * Zi2 + Crb[x + i + 1]
            val nZi2 = Zr2 * Zi2 + Zr2 * Zi2 + Cib[y]
            Zr2 = nZr2
            Zi2 = nZi2

            if (Zr1 * Zr1 + Zi1 * Zi1 > 4) { b = b or 2; if (b == 3) break }
            if (Zr2 * Zr2 + Zi2 * Zi2 > 4) { b = b or 1; if (b == 3) break }
        } while (--j > 0)
        res = (res shl 2) + b
        i += 2
    }
    return res xor -1
}

private fun putLine(y: Int, line: ByteArray) {
    for (xb in line.indices) {
        line[xb] = getByte(xb * 8, y).toByte()
    }
}

fun main(args: Array<String>) {
    var N = 6000
    if (args.isNotEmpty()) N = args[0].toInt()
    if (N <= 200) {
        simpleMandelbrot(N)
        return
    }

    Crb = DoubleArray(N + 7)
    Cib = DoubleArray(N + 7)
    val invN = 2.0 / N
    for (i in 0 until N) {
        Cib[i] = i * invN - 1.0
        Crb[i] = i * invN - 1.5
    }
    yCt = AtomicInteger()
    out = Array(N) { ByteArray((N + 7) / 8) }

    val pool = arrayOfNulls<Thread>(2 * Runtime.getRuntime().availableProcessors())
    for (i in pool.indices) {
        pool[i] = object : Thread() {
            override fun run() {
                var y = yCt.getAndIncrement()
                while (y < out.size) {
                    putLine(y, out[y])
                    y = yCt.getAndIncrement()
                }
            }
        }
    }
    for (t in pool) t!!.start()
    for (t in pool) t!!.join()

    val stream: OutputStream = BufferedOutputStream(System.out)
    stream.write(("P4\n$N $N\n").toByteArray())
    for (i in 0 until N) stream.write(out[i])
    stream.close()
}

private fun simpleMandelbrot(n: Int) {
    val stream: OutputStream = BufferedOutputStream(System.out)
    stream.write(("P4\n$n $n\n").toByteArray())
    val c1 = 2.0 / n
    for (y in 0 until n) {
        val row = ByteArray((n + 7) / 8)
        val ci = y * c1 - 1.0
        for (xByte in row.indices) {
            var bits = 0
            for (bit in 0 until 8) {
                val x = xByte * 8 + bit
                if (x < n && simplePixel(x * c1 - 1.5, ci)) {
                    bits = bits or (128 shr bit)
                }
            }
            row[xByte] = bits.toByte()
        }
        if (n % 8 != 0) {
            val mask = (0xff shl (8 - n % 8)).toByte()
            row[row.size - 1] = (row[row.size - 1].toInt() and mask.toInt()).toByte()
        }
        stream.write(row)
    }
    stream.close()
}

private fun simplePixel(cr: Double, ci: Double): Boolean {
    var zr = cr
    var zi = ci
    for (outer in 0 until 7) {
        for (inner in 0 until 7) {
            val nzr = zr * zr - zi * zi + cr
            zi = zr * zi + zr * zi + ci
            zr = nzr
        }
        if (zr * zr + zi * zi >= 4.0) {
            return false
        }
    }
    return true
}
