class Solution:
    def countVowelPermutation(self, n: int) -> int:
        MOD = 10**9 + 7
        
        # dp arrays for each vowel count at position i
        a = e = i = o = u = 1
        
        for _ in range(2, n+1):
            a_new = (e + i + u) % MOD  # Actually from rules: after 'e' -> 'a', after 'i' -> 'a', after 'u' -> 'a'
            e_new = (a + i) % MOD      # after 'a' -> 'e', after 'i' -> 'e'
            i_new = (e + o) % MOD      # after 'e' -> 'i', after 'o' -> 'i'
            o_new = i % MOD            # after 'i' -> 'o'
            u_new = (i + o) % MOD      # after 'i' -> 'u', after 'o' -> 'u'
            
            # But the problem states:
            # After 'a' only 'e' may appear.
            # After 'e' only 'a' or 'i' may appear.
            # The letter 'i' cannot be followed by another 'i'.
            # After 'o' only 'i' or 'u' may appear.
            # After 'u' only 'a' may appear.
            #
            # So let's rewrite transitions carefully:
            # a -> e
            # e -> a or i
            # i -> a or e or o or u except i (cannot be followed by i)
            # o -> i or u
            # u -> a
            
            # So the transitions are:
            # a_new = count of strings ending with 'a' at position i
            # a can only come after e, i, u? No, from rules:
            # after 'e' -> 'a'
            # after 'i' -> 'a'
            # after 'u' -> 'a'
            # So a_new = e + i + u
            #
            # e_new = after 'a' -> 'e', after 'i' -> 'e'
            # so e_new = a + i
            #
            # i_new = after 'e' -> 'i', after 'o' -> 'i'
            # so i_new = e + o
            #
            # o_new = after 'i' -> 'o'
            # so o_new = i
            #
            # u_new = after 'i' -> 'u', after 'o' -> 'u'
            # so u_new = i + o
            
            a, e, i, o, u = a_new % MOD, e_new % MOD, i_new % MOD, o_new % MOD, u_new % MOD
        
        return (a + e + i + o + u) % MOD
