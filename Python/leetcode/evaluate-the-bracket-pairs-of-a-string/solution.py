class Solution:
    def evaluate(self, s: str, knowledge: List[List[str]]) -> str:
        # Create a dictionary from the knowledge list for quick lookup
        knowledge_dict = {k: v for k, v in knowledge}
        
        stack, word = [], ""
        for char in s:
            if char == "(":
                # Append the current word to the stack and reset it
                stack.append(word)
                word = ""
            elif char == ")":
                # Replace the last word with the value from the dictionary or "?"
                prev_word = stack.pop() + knowledge_dict.get(word, "?")
                word = prev_word
            else:
                # Append current character to the current word
                word += char
        
        return word