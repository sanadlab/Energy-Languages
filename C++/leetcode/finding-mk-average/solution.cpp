class Solution {
    int m = 0, k = 0;
    vector<int> stream;
public:
    int MKAverage(int m_, int k_) {
        m = m_;
        k = k_;
        stream.clear();
        return 0;
    }

    void addElement(int num) {
        stream.push_back(num);
    }

    int calculateMKAverage() {
        int n = stream.size();
        if (n < m) return -1;
        vector<int> last(stream.end() - m, stream.end());
        sort(last.begin(), last.end());
        long long sum = 0;
        int cnt = 0;
        for (int i = k; i < m - k; i++) {
            sum += last[i];
            cnt++;
        }
        if (cnt == 0) return 0;
        return (int)(sum / cnt);
    }
};
