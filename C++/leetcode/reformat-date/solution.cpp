class Solution {
public:
    string reformatDate(string date) {
        unordered_map<string,string> months = {
            {"Jan","01"},{"Feb","02"},{"Mar","03"},{"Apr","04"},
            {"May","05"},{"Jun","06"},{"Jul","07"},{"Aug","08"},
            {"Sep","09"},{"Oct","10"},{"Nov","11"},{"Dec","12"}};
        vector<string> parts;
        istringstream iss(date);
        string tok;
        while (iss >> tok) parts.push_back(tok);
        if (parts.size() < 3) return "";
        string day = parts[0].size() >= 2 ? parts[0].substr(0, parts[0].size() - 2) : parts[0];
        if (day.size() == 1) day = "0" + day;
        string month = months.count(parts[1]) ? months[parts[1]] : string("01");
        return parts[2] + "-" + month + "-" + day;
    }
};
