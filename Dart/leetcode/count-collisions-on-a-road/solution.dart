class Solution {
  int countCollisions(String directions) {
    int n = directions.length;
    int i = 0;
    while (i < n && directions[i] == 'L') {
      i++;
    }
    int j = n - 1;
    while (j >= 0 && directions[j] == 'R') {
      j--;
    }
    int collisions = 0;
    for (int k = i; k <= j; k++) {
      if (directions[k] != 'S') {
        collisions++;
      }
    }
    return collisions;
  }
}
