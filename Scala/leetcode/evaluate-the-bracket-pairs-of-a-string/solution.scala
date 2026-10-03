object Solution {
    def evaluate(s: String, knowledge: List[List[String]]): String = {
        val dict = knowledge.map(kv => (kv(0), kv(1))).toMap
        val stack = scala.collection.mutable.ArrayBuffer[String]()
        var word = ""
        for (ch <- s) {
            if (ch == '(') {
                stack += word
                word = ""
            } else if (ch == ')') {
                word = stack.remove(stack.length - 1) + dict.getOrElse(word, "?")
            } else {
                word += ch
            }
        }
        word
    }
}
