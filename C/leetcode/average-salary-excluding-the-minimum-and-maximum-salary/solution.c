double average(int* salary, int salarySize) {
    int mn = salary[0], mx = salary[0]; long long sum = 0;
    for (int i = 0; i < salarySize; i++) { sum += salary[i]; if (salary[i] < mn) mn = salary[i]; if (salary[i] > mx) mx = salary[i]; }
    return (double)(sum - mn - mx) / (salarySize - 2);
}
