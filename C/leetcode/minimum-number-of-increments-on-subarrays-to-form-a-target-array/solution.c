int minNumberOperations(int* target, int targetSize) {
    if (targetSize == 0) return 0;
    long long ans = target[0];
    for (int i = 1; i < targetSize; i++) {
        if (target[i] > target[i-1]) ans += target[i] - target[i-1];
    }
    return (int)ans;
}
