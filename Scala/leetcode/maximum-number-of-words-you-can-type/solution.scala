object Solution {
    def canBeTypedWords(text: String, brokenLetters: String): Int = {
        val broken = brokenLetters.toSet
        text.split(" ").count(word => word.nonEmpty && !word.exists(broken.contains))
    }
}
