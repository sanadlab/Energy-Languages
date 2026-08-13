class Solution {
public:
    vector<string> ambiguousCoordinates(string s) {
        string digits = s.substr(1, s.size() - 2);
        int n = digits.size();
        vector<string> res;
        for (int i = 1; i < n; i++) {
            vector<string> left = make(digits.substr(0, i));
            vector<string> right = make(digits.substr(i));
            for (auto& a : left)
                for (auto& b : right)
                    res.push_back("(" + a + ", " + b + ")");
        }
        return res;
    }
private:
    vector<string> make(const string& d) {
        vector<string> out;
        int n = d.size();
        if (n == 1) {
            out.push_back(d);
            return out;
        }
        if (d[0] != '0') out.push_back(d);
        for (int i = 1; i < n; i++) {
            string l = d.substr(0, i);
            string r = d.substr(i);
            if ((l == "0" || l[0] != '0') && r.back() != '0')
                out.push_back(l + "." + r);
        }
        return out;
    }
};
