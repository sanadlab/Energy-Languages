/**
 * The Computer Language Benchmarks Game
 * http://benchmarksgame.alioth.debian.org/
 * contributed by Mike Pall
 * java port by Stefan Krause
 * Kotlin port (JVM-to-JVM) of pidigits.java-2.java
 */

import java.math.BigInteger

private class GmpInteger {
    var value: BigInteger = BigInteger.ZERO

    constructor()
    constructor(value: Int) {
        set(value)
    }

    fun set(value: Int) {
        this.value = BigInteger.valueOf(value.toLong())
    }

    fun mul(src: GmpInteger, value: Int) {
        this.value = src.value.multiply(BigInteger.valueOf(value.toLong()))
    }

    fun add(op1: GmpInteger, op2: GmpInteger) {
        value = op1.value.add(op2.value)
    }

    fun div(op1: GmpInteger, op2: GmpInteger) {
        value = op1.value.divide(op2.value)
    }

    fun intValue(): Int = value.toInt()
}

private class Pidigits(private val n: Int) {

    private val q = GmpInteger()
    private val r = GmpInteger()
    private val s = GmpInteger()
    private val t = GmpInteger()
    private val u = GmpInteger()
    private val v = GmpInteger()
    private val w = GmpInteger()

    private var i = 0
    private var strBuf = StringBuilder(20)

    private fun composeR(bq: Int, br: Int, bs: Int, bt: Int) {
        u.mul(r, bs)
        r.mul(r, bq)
        v.mul(t, br)
        r.add(r, v)
        t.mul(t, bt)
        t.add(t, u)
        s.mul(s, bt)
        u.mul(q, bs)
        s.add(s, u)
        q.mul(q, bq)
    }

    /* Compose matrix with numbers on the left. */
    private fun composeL(bq: Int, br: Int, bs: Int, bt: Int) {
        r.mul(r, bt)
        u.mul(q, br)
        r.add(r, u)
        u.mul(t, bs)
        t.mul(t, bt)
        v.mul(s, br)
        t.add(t, v)
        s.mul(s, bq)
        s.add(s, u)
        q.mul(q, bq)
    }

    /* Extract one digit. */
    private fun extract(j: Int): Int {
        u.mul(q, j)
        u.add(u, r)
        v.mul(s, j)
        v.add(v, t)
        w.div(u, v)
        return w.intValue()
    }

    /* Print one digit. Returns true for the last digit. */
    private fun prdigit(y: Int): Boolean {
        strBuf.append(y)
        if (++i % 10 == 0 || i == n) {
            if (i % 10 != 0) {
                var j = 10 - (i % 10)
                while (j > 0) {
                    strBuf.append(" ")
                    j--
                }
            }
            strBuf.append("\t:")
            strBuf.append(i)
            println(strBuf)
            strBuf = StringBuilder(20)
        }
        return i == n
    }

    /* Generate successive digits of PI. */
    fun pidigits() {
        var k = 1
        i = 0
        q.set(1)
        r.set(0)
        s.set(0)
        t.set(1)
        while (true) {
            val y = extract(3)
            if (y == extract(4)) {
                if (prdigit(y)) return
                composeR(10, -10 * y, 0, 1)
            } else {
                composeL(k, 4 * k + 2, 0, 2 * k + 1)
                k++
            }
        }
    }
}

fun main(args: Array<String>) {
    val m = Pidigits(args[0].toInt())
    m.pidigits()
}
