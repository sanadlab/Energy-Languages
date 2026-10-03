class Solution {
    @JvmSuppressWildcards
    fun evaluate(s: String, knowledge: List<List<String>>): String {
        val knowledgeDict = HashMap<String, String>()
        for (pair in knowledge) {
            knowledgeDict[pair[0]] = pair[1]
        }

        val stack = ArrayDeque<String>()
        var word = StringBuilder()
        for (char in s) {
            when (char) {
                '(' -> {
                    stack.addLast(word.toString())
                    word = StringBuilder()
                }
                ')' -> {
                    val prevWord = stack.removeLast() + (knowledgeDict[word.toString()] ?: "?")
                    word = StringBuilder(prevWord)
                }
                else -> {
                    word.append(char)
                }
            }
        }

        return word.toString()
    }
}
