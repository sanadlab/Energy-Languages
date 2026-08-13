class Solution:
    def licenseKeyFormatting(self, s: str, k: int) -> str:
        # Remove dashes and convert to uppercase
        cleaned = s.replace('-', '').upper()
        
        # Calculate the length of the first group
        first_group_len = len(cleaned) % k
        
        result = []
        if first_group_len > 0:
            result.append(cleaned[:first_group_len])
        
        # Add remaining characters in groups of k
        for i in range(first_group_len, len(cleaned), k):
            result.append(cleaned[i:i + k])
        
        return '-'.join(result)