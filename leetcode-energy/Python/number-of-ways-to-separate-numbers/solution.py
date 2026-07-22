from array import array

class Solution:
    def numberOfCombinations(self, num: str) -> int:
        MOD = 1_000_000_007
        n = len(num)
        
        if num[0] == '0':
            return 0
        
        lcp = [array('H', [0]) * (n + 1) for _ in range(n + 1)]
        
        for i in range(n - 1, -1, -1):
            row = lcp[i]
            next_row = lcp[i + 1]
            c = num[i]
            for j in range(n - 1, i, -1):
                if c == num[j]:
                    row[j] = next_row[j + 1] + 1
        
        pref = [array('I', [0])]
        
        for i in range(1, n + 1):
            row = array('I', [0]) * (i + 1)
            
            for length in range(1, i + 1):
                start = i - length
                val = 0
                
                if num[start] != '0':
                    if start == 0:
                        val = 1
                    else:
                        prev_row = pref[start]
                        shorter = length - 1
                        if shorter > start:
                            shorter = start
                        
                        val = prev_row[shorter]
                        
                        if start >= length:
                            prev_start = start - length
                            common = lcp[prev_start][start]
                            
                            if common >= length or num[prev_start + common] <= num[start + common]:
                                add = prev_row[length] - prev_row[length - 1]
                                if add < 0:
                                    add += MOD
                                val += add
                                if val >= MOD:
                                    val -= MOD
                
                total = row[length - 1] + val
                if total >= MOD:
                    total -= MOD
                row[length] = total
            
            pref.append(row)
        
        return pref[n][n]
