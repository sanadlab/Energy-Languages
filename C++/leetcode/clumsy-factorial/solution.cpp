class Solution {
public:
    int clumsy(int n) {
        int result = 0;
        int sign = 1; // +1 or -1 for addition or subtraction
        int i = n;
        int op = 0; // 0: *, 1: /, 2: +, 3: -
        
        // We use a variable to hold the intermediate multiplication/division result
        int temp = i;
        i--;
        
        while (i > 0) {
            if (op == 0) {
                temp = temp * i;
            } else if (op == 1) {
                temp = temp / i;
            } else if (op == 2) {
                // When we reach +, add the previous temp with sign to result
                result += sign * temp;
                temp = i;
                sign = 1;
            } else { // op == 3
                // When we reach -, add the previous temp with sign to result
                result += sign * temp;
                temp = i;
                sign = -1;
            }
            op = (op + 1) % 4;
            i--;
        }
        // Add the last temp value
        result += sign * temp;
        return result;
    }
};