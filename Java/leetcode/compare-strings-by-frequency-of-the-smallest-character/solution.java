import java.util.Arrays;

class Solution {
    public int[] numSmallerByFrequency(String[] queries, String[] words) {
        int[] wordFrequencies = new int[words.length];
        
        // Calculate f(W) for each word in words and store it.
        for (int i = 0; i < words.length; ++i) {
            wordFrequencies[i] = f(words[i]);
        }
        
        // Sort the frequencies of words to facilitate binary search.
        Arrays.sort(wordFrequencies);
        
        int[] result = new int[queries.length];
        
        // For each query, find how many words have a higher frequency.
        for (int i = 0; i < queries.length; ++i) {
            result[i] = words.length - binarySearch(wordFrequencies, f(queries[i]));
        }
        
        return result;
    }

    private int f(String s) {
        char minChar = 'z';
        int count = 0;
        
        for (char c : s.toCharArray()) {
            if (c < minChar) {
                minChar = c;
                count = 1;
            } else if (c == minChar) {
                ++count;
            }
        }
        
        return count;
    }

    private int binarySearch(int[] arr, int target) {
        int left = 0, right = arr.length - 1;
        
        while (left <= right) {
            int mid = left + (right - left) / 2;
            
            if (arr[mid] > target) {
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }
        
        return left;
    }
}