class Solution {
    public function isSumEqual(string $firstWord, string $secondWord, string $targetWord): bool {
        $val1 = $this->getNumericalValue($firstWord);
        $val2 = $this->getNumericalValue($secondWord);
        $target = $this->getNumericalValue($targetWord);
        return ($val1 + $val2) == $target;
    }

    private function getNumericalValue(string $s): int {
        $result = '';
        for ($i = 0; $i < strlen($s); $i++) {
            $char = $s[$i];
            $value = ord($char) - ord('a');
            $result .= strval($value);
        }
        return (int)$result;
    }
}