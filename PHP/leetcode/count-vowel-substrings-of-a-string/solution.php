/**
 * Definition for a class Solution.
 * Implementation details for the LeetCode environment.
 */
class Solution {
    /**
     * Counts the number of vowel substrings that contain all five vowels ('a', 'e', 'i', 'o', 'u').
     *
     * @param string $word The input string.
     * @return int The total count of vowel substrings.
     */
    function countVowelSubstrings(string $word): int {
        $vowels = ['a', 'e', 'i', 'o', 'u'];
        $n = strlen($word);
        $total_count = 0;

        $i = 0;
        while ($i < $n) {
            // 1. Skip consonants
            if (!in_array($word[$i], $vowels)) {
                $i++;
                continue;
            }

            // 2. Found start of a vowel block
            $start_block = $i;
            $j = $i;
            while ($j < $n && in_array($word[$j], $vowels)) {
                $j++;
            }
            // The block is word[start_block] to word[j-1]
            $end_block = $j - 1;
            $block_length = $end_block - $start_block + 1;

            // Extract the vowel block B
            $B = substr($word, $start_block, $block_length);
            $L = strlen($B);

            // 3. Process the block B: Check all substrings of B
            for ($s = 0; $s < $L; $s++) { // Start index relative to B
                $vowel_set = [];
                for ($e = $s; $e < $L; $e++) { // End index relative to B
                    $char = $B[$e];
                    $vowel_set[$char] = true;

                    // Check if all 5 vowels are present
                    if (count($vowel_set) == 5) {
                        $total_count++;
                    }
                }
            }

            // Move i past this processed block
            $i = $j;
        }

        return $total_count;
    }
}