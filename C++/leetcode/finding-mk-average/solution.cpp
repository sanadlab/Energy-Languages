#include <vector>
#include <algorithm>
using namespace std;

class MKAverage {
public:
    int m, k;
    vector<int> stream;

    MKAverage(int m, int k) {
        this->m = m;
        this->k = k;
    }

    void addElement(int num) {
        stream.push_back(num);
    }

    int calculateMKAverage() {
        if ((int)stream.size() < m) return -1;
        vector<int> last(stream.end() - m, stream.end());
        sort(last.begin(), last.end());
        if (m - k <= k) return 0;            // trimmed slice last[k:m-k] is empty
        long long sum = 0;
        int cnt = 0;
        for (int i = k; i < m - k; i++) { sum += last[i]; cnt++; }
        return (int)(sum / cnt);
    }
};
