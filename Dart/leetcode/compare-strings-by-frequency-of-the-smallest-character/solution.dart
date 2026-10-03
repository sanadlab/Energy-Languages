class Solution {
  List<int> numSmallerByFrequency(List<String> queries, List<String> words) {
    List<int> wordFrequencies = [];
    for (String w in words) {
      wordFrequencies.add(_f(w));
    }
    wordFrequencies.sort((a, b) => a - b);

    List<int> result = [];
    for (String q in queries) {
      result.add(words.length - _binarySearch(wordFrequencies, _f(q)));
    }
    return result;
  }

  int _f(String s) {
    int minChar = 'z'.codeUnitAt(0);
    int count = 0;
    for (int i = 0; i < s.length; i++) {
      int c = s.codeUnitAt(i);
      if (c < minChar) {
        minChar = c;
        count = 1;
      } else if (c == minChar) {
        count++;
      }
    }
    return count;
  }

  int _binarySearch(List<int> arr, int target) {
    int left = 0, right = arr.length - 1;
    while (left <= right) {
      int mid = left + (right - left) ~/ 2;
      if (arr[mid] > target) {
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }
    return left;
  }
}
