class Solution:
    def licenseKeyFormatting(self, s: str, k: int) -> str:
        # Remove dashes and convert to uppercase
        s = s.replace('-', '').upper()
        
        # Calculate the length of the first group
        first_group_len = len(s) % k
        if first_group_len == 0 and len(s) > 0:
            first_group_len = k
        
        # Build the groups
        groups = []
        groups.append(s[:first_group_len])
        for i in range(first_group_len, len(s), k):
            groups.append(s[i:i+k])
        
        return '-'.join(groups)
