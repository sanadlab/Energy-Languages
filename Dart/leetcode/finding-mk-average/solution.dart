class MKAverage {
  final int m, k;
  final List<int> stream = [];
  MKAverage(this.m, this.k);
  void addElement(int num) { stream.add(num); }
  int calculateMKAverage() {
    if (stream.length < m) return -1;
    final last = stream.sublist(stream.length - m)..sort();
    int sum = 0;
    for (int i = k; i < m - k; i++) sum += last[i];
    return sum ~/ (m - 2 * k);
  }
}
