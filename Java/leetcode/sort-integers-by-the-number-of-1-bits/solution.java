import java.util.*;

class Solution {
    public int[] sortByBits(int[] arr) {
        Integer[] boxed = new Integer[arr.length];
        for (int i = 0; i < arr.length; i++) boxed[i] = arr[i];
        Arrays.sort(boxed, (a, b) -> {
            int pa = Integer.bitCount(a), pb = Integer.bitCount(b);
            if (pa != pb) return pa - pb;
            return a - b;
        });
        int[] res = new int[arr.length];
        for (int i = 0; i < arr.length; i++) res[i] = boxed[i];
        return res;
    }
}
