class Solution {
public:
    double average(vector<int>& salary) {
        int mn = salary[0], mx = salary[0], sum = 0;
        for (int s : salary) { sum += s; mn = min(mn, s); mx = max(mx, s); }
        return (double)(sum - mn - mx) / (salary.size() - 2);
    }
};
