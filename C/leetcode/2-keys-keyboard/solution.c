int minSteps(int n) {
    int steps = 0, d = 2;
    while (n > 1) { while (n % d == 0) { steps += d; n /= d; } d++; }
    return steps;
}
