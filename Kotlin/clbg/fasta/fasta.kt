/*
 * The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 *
 * modified by Mehmet D. AKIN
 * modified by Daryl Griffith
 *
 * Kotlin port (JVM-to-JVM) of fasta.java-5.java
 */

import java.io.IOException
import java.io.OutputStream
import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.BlockingQueue
import java.util.concurrent.atomic.AtomicInteger

private const val LINE_LENGTH = 60
private const val LINE_COUNT = 1024
private val WORKERS: Array<NucleotideSelector?> = arrayOfNulls(
    if (Runtime.getRuntime().availableProcessors() > 1)
        Runtime.getRuntime().availableProcessors() - 1
    else
        1
)
private val IN = AtomicInteger()
private val OUT = AtomicInteger()
private const val BUFFERS_IN_PLAY = 6
private const val IM = 139968
private const val IA = 3877
private const val IC = 29573
private val ONE_OVER_IM = 1f / IM
private var last = 42

private const val ALU_STR =
    "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG" +
        "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA" +
        "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT" +
        "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA" +
        "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG" +
        "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC" +
        "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

fun main(args: Array<String>) {
    var n = 1000

    if (args.isNotEmpty()) {
        n = args[0].toInt()
    }
    if (n < LINE_COUNT * LINE_LENGTH * BUFFERS_IN_PLAY) {
        try {
            simpleFasta(System.out, n)
        } catch (ex: IOException) {
        }
        return
    }
    for (i in WORKERS.indices) {
        WORKERS[i] = NucleotideSelector()
        WORKERS[i]!!.isDaemon = true
        WORKERS[i]!!.start()
    }
    try {
        val writer: OutputStream = System.out
        writer.use {
            val bufferSize = LINE_COUNT * LINE_LENGTH

            for (i in 0 until BUFFERS_IN_PLAY) {
                lineFillALU(AluBuffer(LINE_LENGTH, bufferSize, i * bufferSize))
            }
            speciesFillALU(writer, n * 2, ">ONE Homo sapiens alu\n")
            for (i in 0 until BUFFERS_IN_PLAY) {
                writeBuffer(writer)
                lineFillRandom(Buffer(true, LINE_LENGTH, bufferSize))
            }
            speciesFillRandom(writer, n * 3, ">TWO IUB ambiguity codes\n", true)
            for (i in 0 until BUFFERS_IN_PLAY) {
                writeBuffer(writer)
                lineFillRandom(Buffer(false, LINE_LENGTH, bufferSize))
            }
            speciesFillRandom(writer, n * 5, ">THREE Homo sapiens frequency\n", false)
            for (i in 0 until BUFFERS_IN_PLAY) {
                writeBuffer(writer)
            }
        }
    } catch (ex: IOException) {
    }
}

private fun simpleFasta(writer: OutputStream, n: Int) {
    val alu = ALU_STR.toByteArray(Charsets.ISO_8859_1)
    val iubChars = byteArrayOf(
        'a'.code.toByte(), 'c'.code.toByte(), 'g'.code.toByte(), 't'.code.toByte(),
        'B'.code.toByte(), 'D'.code.toByte(), 'H'.code.toByte(), 'K'.code.toByte(),
        'M'.code.toByte(), 'N'.code.toByte(), 'R'.code.toByte(), 'S'.code.toByte(),
        'V'.code.toByte(), 'W'.code.toByte(), 'Y'.code.toByte()
    )
    val iubProbs = doubleArrayOf(
        0.27, 0.12, 0.12, 0.27, 0.02, 0.02, 0.02, 0.02,
        0.02, 0.02, 0.02, 0.02, 0.02, 0.02, 0.02
    )
    val sapienChars = byteArrayOf('a'.code.toByte(), 'c'.code.toByte(), 'g'.code.toByte(), 't'.code.toByte())
    val sapienProbs = doubleArrayOf(0.3029549426680, 0.1979883004921, 0.1975473066391, 0.3015094502008)

    writer.write(">ONE Homo sapiens alu\n".toByteArray(Charsets.ISO_8859_1))
    writeRepeat(writer, alu, n * 2)
    writer.write(">TWO IUB ambiguity codes\n".toByteArray(Charsets.ISO_8859_1))
    writeRandom(writer, iubChars, cumulative(iubProbs), n * 3)
    writer.write(">THREE Homo sapiens frequency\n".toByteArray(Charsets.ISO_8859_1))
    writeRandom(writer, sapienChars, cumulative(sapienProbs), n * 5)
}

private fun cumulative(probabilities: DoubleArray): DoubleArray {
    val result = DoubleArray(probabilities.size)
    var sum = 0.0
    for (i in probabilities.indices) {
        sum += probabilities[i]
        result[i] = sum
    }
    return result
}

private fun writeRepeat(writer: OutputStream, sequence: ByteArray, count: Int) {
    var i = 0
    while (i < count) {
        val line = Math.min(LINE_LENGTH, count - i)
        for (j in 0 until line) {
            writer.write(sequence[(i + j) % sequence.size].toInt())
        }
        writer.write('\n'.code)
        i += LINE_LENGTH
    }
}

private fun writeRandom(writer: OutputStream, chars: ByteArray, probs: DoubleArray, count: Int) {
    var i = 0
    while (i < count) {
        val line = Math.min(LINE_LENGTH, count - i)
        for (j in 0 until line) {
            val r = nextRandom()
            var k = 0
            while (probs[k] < r) {
                k++
            }
            writer.write(chars[k].toInt())
        }
        writer.write('\n'.code)
        i += LINE_LENGTH
    }
}

private fun nextRandom(): Double {
    last = (last * IA + IC) % IM
    return last * (1.0 / IM)
}

private fun lineFillALU(buffer: AbstractBuffer) {
    WORKERS[OUT.incrementAndGet() % WORKERS.size]!!.put(buffer)
}

private fun bufferFillALU(writer: OutputStream, buffers: Int) {
    for (i in 0 until buffers) {
        val buffer = WORKERS[IN.incrementAndGet() % WORKERS.size]!!.take()!!
        writer.write(buffer.nucleotides)
        lineFillALU(buffer)
    }
}

private fun speciesFillALU(writer: OutputStream, nChars: Int, name: String) {
    val bufferSize = LINE_COUNT * LINE_LENGTH
    val bufferCount = nChars / bufferSize
    val bufferLoops = bufferCount - BUFFERS_IN_PLAY
    val charsLeftover = nChars - (bufferCount * bufferSize)

    writer.write(name.toByteArray(Charsets.ISO_8859_1))
    bufferFillALU(writer, bufferLoops)
    if (charsLeftover > 0) {
        writeBuffer(writer)
        lineFillALU(AluBuffer(LINE_LENGTH, charsLeftover, nChars - charsLeftover))
    }
}

private fun lineFillRandom(buffer: Buffer) {
    for (i in buffer.randoms.indices) {
        last = (last * IA + IC) % IM
        buffer.randoms[i] = last * ONE_OVER_IM
    }
    WORKERS[OUT.incrementAndGet() % WORKERS.size]!!.put(buffer)
}

private fun bufferFillRandom(writer: OutputStream, loops: Int) {
    for (i in 0 until loops) {
        val buffer = WORKERS[IN.incrementAndGet() % WORKERS.size]!!.take()!!
        writer.write(buffer.nucleotides)
        lineFillRandom(buffer as Buffer)
    }
}

private fun speciesFillRandom(writer: OutputStream, nChars: Int, name: String, isIUB: Boolean) {
    val bufferSize = LINE_COUNT * LINE_LENGTH
    val bufferCount = nChars / bufferSize
    val bufferLoops = bufferCount - BUFFERS_IN_PLAY
    val charsLeftover = nChars - (bufferCount * bufferSize)

    writer.write(name.toByteArray(Charsets.ISO_8859_1))
    bufferFillRandom(writer, bufferLoops)
    if (charsLeftover > 0) {
        writeBuffer(writer)
        lineFillRandom(Buffer(isIUB, LINE_LENGTH, charsLeftover))
    }
}

private fun writeBuffer(writer: OutputStream) {
    writer.write(
        WORKERS[IN.incrementAndGet() % WORKERS.size]!!
            .take()!!
            .nucleotides
    )
}

private class NucleotideSelector : Thread() {

    private val `in`: BlockingQueue<AbstractBuffer> = ArrayBlockingQueue(BUFFERS_IN_PLAY)
    private val out: BlockingQueue<AbstractBuffer> = ArrayBlockingQueue(BUFFERS_IN_PLAY)

    fun put(line: AbstractBuffer) {
        try {
            `in`.put(line)
        } catch (ex: InterruptedException) {
        }
    }

    override fun run() {
        var line: AbstractBuffer
        try {
            while (true) {
                line = `in`.take()
                line.selectNucleotides()
                out.put(line)
            }
        } catch (ex: InterruptedException) {
        }
    }

    fun take(): AbstractBuffer? {
        try {
            return out.take()
        } catch (ex: InterruptedException) {
        }
        return null
    }
}

private abstract class AbstractBuffer(lineLength: Int, nChars: Int) {

    val LINE_LENGTH: Int = lineLength
    val LINE_COUNT: Int
    var chars: ByteArray? = null
    val nucleotides: ByteArray
    val CHARS_LEFTOVER: Int

    init {
        val outputLineLength = lineLength + 1
        LINE_COUNT = nChars / lineLength
        CHARS_LEFTOVER = nChars % lineLength
        val nucleotidesSize = nChars + LINE_COUNT + (if (CHARS_LEFTOVER == 0) 0 else 1)
        val lastNucleotide = nucleotidesSize - 1

        nucleotides = ByteArray(nucleotidesSize)
        var i = lineLength
        while (i < lastNucleotide) {
            nucleotides[i] = '\n'.code.toByte()
            i += outputLineLength
        }
        nucleotides[nucleotides.size - 1] = '\n'.code.toByte()
    }

    abstract fun selectNucleotides()
}

private class AluBuffer(lineLength: Int, nChars: Int, offset: Int) : AbstractBuffer(lineLength, nChars) {

    val ALU = ALU_STR
    val MAX_ALU_INDEX = ALU.length - LINE_LENGTH
    val ALU_ADJUST = LINE_LENGTH - ALU.length
    val nChars: Int = nChars
    var charIndex: Int = offset % ALU.length
    var nucleotideIndex = 0

    init {
        chars = (ALU + ALU.substring(0, LINE_LENGTH)).toByteArray(Charsets.ISO_8859_1)
    }

    override fun selectNucleotides() {
        nucleotideIndex = 0
        for (i in 0 until LINE_COUNT) {
            aluFillLine(LINE_LENGTH)
        }
        if (CHARS_LEFTOVER > 0) {
            aluFillLine(CHARS_LEFTOVER)
        }
        charIndex = (charIndex + (nChars * (BUFFERS_IN_PLAY - 1))) % ALU.length
    }

    private fun aluFillLine(charCount: Int) {
        System.arraycopy(chars!!, charIndex, nucleotides, nucleotideIndex, charCount)
        charIndex += if (charIndex < MAX_ALU_INDEX) charCount else ALU_ADJUST
        nucleotideIndex += charCount + 1
    }
}

private class Buffer(isIUB: Boolean, lineLength: Int, nChars: Int) : AbstractBuffer(lineLength, nChars) {

    val iubChars = byteArrayOf(
        'a'.code.toByte(), 'c'.code.toByte(), 'g'.code.toByte(), 't'.code.toByte(),
        'B'.code.toByte(), 'D'.code.toByte(), 'H'.code.toByte(), 'K'.code.toByte(),
        'M'.code.toByte(), 'N'.code.toByte(), 'R'.code.toByte(), 'S'.code.toByte(),
        'V'.code.toByte(), 'W'.code.toByte(), 'Y'.code.toByte()
    )
    val iubProbs = doubleArrayOf(
        0.27, 0.12, 0.12, 0.27,
        0.02, 0.02, 0.02, 0.02,
        0.02, 0.02, 0.02, 0.02,
        0.02, 0.02, 0.02
    )
    val sapienChars = byteArrayOf(
        'a'.code.toByte(),
        'c'.code.toByte(),
        'g'.code.toByte(),
        't'.code.toByte()
    )
    val sapienProbs = doubleArrayOf(
        0.3029549426680,
        0.1979883004921,
        0.1975473066391,
        0.3015094502008
    )
    val probs: FloatArray
    val randoms: FloatArray
    val charsInFullLines: Int

    init {
        var cp = 0.0
        val dblProbs = if (isIUB) iubProbs else sapienProbs

        chars = if (isIUB) iubChars else sapienChars
        probs = FloatArray(dblProbs.size)
        for (i in probs.indices) {
            cp += dblProbs[i]
            probs[i] = cp.toFloat()
        }
        probs[probs.size - 1] = 2f
        randoms = FloatArray(nChars)
        charsInFullLines = (nChars / lineLength) * lineLength
    }

    override fun selectNucleotides() {
        var i = 0
        var j = 0
        var m: Int
        var r: Float
        var k: Int

        while (i < charsInFullLines) {
            k = 0
            while (k < LINE_LENGTH) {
                r = randoms[i++]
                m = 0
                while (probs[m] < r) {
                    m++
                }
                nucleotides[j++] = chars!![m]
                k++
            }
            j++
        }
        k = 0
        while (k < CHARS_LEFTOVER) {
            r = randoms[i++]
            m = 0
            while (probs[m] < r) {
                m++
            }
            nucleotides[j++] = chars!![m]
            k++
        }
    }
}
