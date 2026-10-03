int maxCompatibilitySum(int** students, int studentsSize, int* studentsColSize, int** mentors, int mentorsSize, int* mentorsColSize) {
    int m = studentsSize;
    int n = m ? studentsColSize[0] : 0;
    int score[8][8] = {{0}};
    for (int i = 0; i < m; i++)
        for (int j = 0; j < m; j++) {
            int c = 0;
            for (int k = 0; k < n; k++)
                if (students[i][k] == mentors[j][k]) c++;
            score[i][j] = c;
        }
    int sz = 1 << m;
    int* dp = (int*) calloc(sz, sizeof(int));
    for (int mask = 0; mask < sz; mask++) {
        int i = __builtin_popcount(mask);
        if (i >= m) continue;
        for (int j = 0; j < m; j++) {
            if ((mask >> j) & 1) continue;
            int nm = mask | (1 << j);
            int val = dp[mask] + score[i][j];
            if (val > dp[nm]) dp[nm] = val;
        }
    }
    int ans = dp[sz - 1];
    free(dp);
    return ans;
}
