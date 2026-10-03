object Solution {
    def ladderLength(beginWord: String, endWord: String, wordList: List[String]): Int = {
        if (!wordList.contains(endWord)) 0
        else {
            val wordSet = wordList.toSet
            val queue = scala.collection.mutable.Queue[(String, Int)]()
            queue.enqueue((beginWord, 1))
            val visited = scala.collection.mutable.Set[String](beginWord)
            var result = 0
            var done = false
            while (queue.nonEmpty && !done) {
                val (currentWord, level) = queue.dequeue()
                var i = 0
                while (i < currentWord.length && !done) {
                    var c = 'a'
                    while (c <= 'z' && !done) {
                        val nextWord = currentWord.substring(0, i) + c + currentWord.substring(i + 1)
                        if (nextWord == endWord) {
                            result = level + 1
                            done = true
                        } else if (wordSet.contains(nextWord) && !visited.contains(nextWord)) {
                            queue.enqueue((nextWord, level + 1))
                            visited.add(nextWord)
                        }
                        c = (c + 1).toChar
                    }
                    i += 1
                }
            }
            result
        }
    }
}
