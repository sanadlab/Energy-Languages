class Solution:
    def evaluate(self, s: str, knowledge: list[list[str]]) -> str:
        # Build a dictionary for quick lookup
        knowledge_dict = {k: v for k, v in knowledge}
        
        res = []
        i = 0
        n = len(s)
        
        while i < n:
            if s[i] == '(':
                # Find the closing parenthesis
                j = i + 1
                while j < n and s[j] != ')':
                    j += 1
                key = s[i+1:j]
                # Append the value or "?" if not found
                res.append(knowledge_dict.get(key, "?"))
                i = j + 1
            else:
                res.append(s[i])
                i += 1
        
        return "".join(res)
