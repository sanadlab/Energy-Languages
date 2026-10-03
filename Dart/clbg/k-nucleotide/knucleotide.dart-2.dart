/**
 * The Computer Language Benchmarks Game
 *
 * http://benchmarksgame.alioth.debian.org/
 *
 * Contributed by Dwayne Slater
 * Based on a Java implementation by James McIlree and Tagir Valeev
 */

library knucleotide;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

const codes = const [-1, 0, -1, 1, 3, -1, -1, 2];
const nucleotides = 'ACGT';

/**
 * Contains a map from keys to occurrence count.
 */
class Result {
  final Map<int, int> map = {};
  Result();

  @override
  String toString() => "$map";
}

/**
 * A pair of keys to counts.
 */
class KeyPair {
  final String key;
  final int count;
  KeyPair(this.key, this.count);
}

/**
 * Converts a slice of the sequence into a key.
 */
int getKey(List<int> arr, int offset, int length) {
  int key = 0;
  int lastOffset = offset + length;
  for (int i = offset; i < lastOffset; i++) {
    key = (key << 2) + arr[i];
  }
  return key;
}

/**
 * Creates a map of all the times any key of the given length occurs in the
 * sequence (counting every overlapping fragment).
 */
Result createFragmentMap(List<int> sequence, int fragmentLength) {
  var res = new Result();
  int lastIndex = sequence.length - fragmentLength + 1;
  for (int index = 0; index < lastIndex; index++) {
    var key = getKey(sequence, index, fragmentLength);
    res.map[key] = (res.map[key] ?? 0) + 1;
  }
  return res;
}

/**
 * Converts a key to a string.
 */
String keyToString(int key, int length) {
  var res = new List<String>.filled(length, '');
  for (int i = 0; i < length; i++) {
    res[length - i - 1] = nucleotides[key & 0x3];
    key >>= 2;
  }
  return res.join();
}

/**
 * Write out the frequencies for each key that appears in the given [Result].
 */
String writeFrequencies(double totalCount, int keyLength, Result frequencies) {
  var freq = <KeyPair>[];
  frequencies.map.forEach((key, cnt) => freq.add(new KeyPair(keyToString(key, keyLength), cnt)));
  freq.sort((a, b) => b.count.compareTo(a.count));
  var sb = new StringBuffer();
  freq.forEach((entry) {
    sb.write("${entry.key} ${(entry.count * 100.0/totalCount).toStringAsFixed(3)}\n");
  });
  return (sb..write("\n")).toString();
}

/**
 * Converts a character list into a list of codes.
 */
List<int> toCodes(List<int> sequence) {
  var l = sequence.length;
  var result = new List<int>.filled(l, 0);
  for (int i = 0; i < l; i++) {
    result[i] = codes[sequence[i] & 0x7];
  }
  return result;
}

/**
 * Write out the occurrences of the given nucleotideFragment in the result.
 */
String writeCount(Result result, String nucleotideFragment) {
  var key = toCodes(nucleotideFragment.codeUnits);
  var k = getKey(key, 0, key.length);
  var count = result.map[k] ?? 0;
  return "$count\t$nucleotideFragment\n";
}

/**
 * Reads sequence data from stdin.
 */
Future<List<int>> read() async {
  var three = false;
  var builder = new BytesBuilder(copy: false);
  late StreamSubscription<String> sub;
  sub = stdin
      .transform(const Latin1Decoder())
      .transform(const LineSplitter())
      .listen((line) {
    if (three) {
      if (line[0] != '>') {
        builder.add(line.codeUnits);
      } else {
        sub.cancel();
      }
    } else if (line.startsWith('>THREE')) {
      three = true;
    }
  });
  await sub.asFuture();
  var bytes = builder.takeBytes();
  return toCodes(bytes);
}

main() async {
  // Read the data from stdin
  var sequence = await read();

  var sb = new StringBuffer();
  // Frequencies with a fragment length of 1
  sb.write(writeFrequencies(
      sequence.length.toDouble(), 1, createFragmentMap(sequence, 1)));
  // Frequencies with a fragment length of 2
  sb.write(writeFrequencies(
      (sequence.length - 1).toDouble(), 2, createFragmentMap(sequence, 2)));
  // Occurrences of each of the nucleotideFragments
  const ["GGT", "GGTA", "GGTATT", "GGTATTTTAATT", "GGTATTTTAATTTATAGT"]
      .forEach((nucleotideFragment) {
    sb.write(writeCount(
        createFragmentMap(sequence, nucleotideFragment.length), nucleotideFragment));
  });

  stdout.write(sb.toString());
}
