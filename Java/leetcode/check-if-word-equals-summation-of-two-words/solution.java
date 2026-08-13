class Solution {
    public boolean isSumEqual(String firstWord, String secondWord, String targetWord) {
        int num1 = 0, num2 = 0, num3 = 0;
        for (char c : firstWord.toCharArray()) {
            num1 = num1 * 10 + (c - 'a');
        }
        for (char c : secondWord.toCharArray()) {
            num2 = num2 * 10 + (c - 'a');
        }
        for (char c : targetWord.toCharArray()) {
            num3 = num3 * 10 + (c - 'a');
        }
        return num1 + num2 == num3;
    }
}