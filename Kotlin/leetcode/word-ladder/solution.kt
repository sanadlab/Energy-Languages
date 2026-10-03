class Solution {
    fun ladderLength(beginWord: String, endWord: String, wordList: List<String>): Int {
        if (endWord !in wordList) return 0

        val wordSet = HashSet(wordList)
        val queue = ArrayDeque<Pair<String, Int>>()
        queue.addLast(Pair(beginWord, 1))
        val visited = HashSet<String>()
        visited.add(beginWord)

        while (queue.isNotEmpty()) {
            val (current, level) = queue.removeFirst()
            for (i in current.indices) {
                for (c in 'a'..'z') {
                    val next = current.substring(0, i) + c + current.substring(i + 1)
                    if (next == endWord) return level + 1
                    if (next in wordSet && next !in visited) {
                        queue.addLast(Pair(next, level + 1))
                        visited.add(next)
                    }
                }
            }
        }

        return 0
    }
}
