class Solution {

    /**
     * @param String $beginWord
     * @param String $endWord
     * @param String[] $wordList
     * @return Integer
     */
    function ladderLength($beginWord, $endWord, $wordList) {
        $wordSet = array_flip($wordList);
        if (!isset($wordSet[$endWord])) {
            return 0;
        }

        $queue = new SplQueue();
        $queue->enqueue([$beginWord, 1]);

        $visited = [];
        $visited[$beginWord] = true;

        $wordLen = strlen($beginWord);

        while (!$queue->isEmpty()) {
            list($word, $level) = $queue->dequeue();

            if ($word === $endWord) {
                return $level;
            }

            for ($i = 0; $i < $wordLen; $i++) {
                $chars = str_split($word);
                for ($c = ord('a'); $c <= ord('z'); $c++) {
                    $chars[$i] = chr($c);
                    $nextWord = implode('', $chars);
                    if (isset($wordSet[$nextWord]) && !isset($visited[$nextWord])) {
                        $visited[$nextWord] = true;
                        $queue->enqueue([$nextWord, $level + 1]);
                    }
                }
            }
        }

        return 0;
    }
}