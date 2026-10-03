int sumOddLengthSubarrays(int* arr, int arrSize) {
    int total = 0;
    for (int i = 0; i < arrSize; i++) {
        int count = ((i + 1) * (arrSize - i) + 1) / 2;
        total += count * arr[i];
    }
    return total;
}
