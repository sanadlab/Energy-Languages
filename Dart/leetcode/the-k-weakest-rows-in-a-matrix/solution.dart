class Solution {
  List<int> kWeakestRows(List<List<int>> mat, int k) {
    List<List<int>> counts = [];
    for (int i = 0; i < mat.length; i++) {
      int sum = 0;
      for (int x in mat[i]) {
        sum += x;
      }
      counts.add([sum, i]);
    }

    counts.sort((a, b) {
      if (a[0] != b[0]) return a[0] - b[0];
      return a[1] - b[1];
    });

    List<int> result = [];
    for (int j = 0; j < k && j < counts.length; j++) {
      result.add(counts[j][1]);
    }
    return result;
  }
}
