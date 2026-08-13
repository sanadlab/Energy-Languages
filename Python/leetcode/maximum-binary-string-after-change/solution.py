class Solution:
    def maximumBinaryString(self, binary):
        n = len(binary)
        first = binary.find('0')
        if first == -1:
            return binary
        zeros = binary.count('0')
        res = ['1'] * n
        res[first + zeros - 1] = '0'
        return ''.join(res)
