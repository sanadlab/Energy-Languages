/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/

   contributed by Sébastien Arnaud
*/

String pad(int i, bool last) {
  var res = i.toString();
  var count = 10 - res.length;
  while (count > 0) {
    last ? res += ' ' : res = '0' + res;
    count--;
  }
  return res;
}

void calculatePi(int N) {
  var i = 0, ns = 0;

  BigInt bigint_TEN = BigInt.from(10);
  BigInt k = BigInt.zero;
  BigInt k1 = BigInt.one;
  BigInt a = BigInt.zero;
  BigInt d = BigInt.one;
  BigInt m = BigInt.zero;
  BigInt n = BigInt.one;
  BigInt t = BigInt.zero;
  BigInt u = BigInt.zero;

  while (true) {
    k = k + BigInt.one;
    k1 = k1 + BigInt.two;
    t = n << 1;
    n = n * k;
    a = (a + t) * k1;
    d = d * k1;

    if (a.compareTo(n) >= 0) {
      m = n * BigInt.from(3) + a;
      t = m ~/ d;
      u = m % d + n;

      if (d.compareTo(u) > 0) {
        ns = ns * 10 + t.toInt();
        i += 1;

        var last = i >= N;
        if (i % 10 == 0 || last) {
          print(pad(ns, last) + '\t:$i');
          ns = 0;
        }

        if (last) break;

        a = (a - d * t) * bigint_TEN;
        n = n * bigint_TEN;
      }
    }
  }
}

void main(List<String> arguments) {
  int N = int.parse(arguments[0]);
  calculatePi(N);
}
