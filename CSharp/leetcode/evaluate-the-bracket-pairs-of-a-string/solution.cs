using System;
using System.Collections.Generic;
using System.Text;

public class Solution {
    public string Evaluate(string s, IList<IList<string>> knowledge) {
        var values = new Dictionary<string, string>(
            knowledge.Count, StringComparer.Ordinal);

        foreach (var entry in knowledge) {
            values[entry[0]] = entry[1];
        }

        var result = new StringBuilder(s.Length);

        for (int i = 0; i < s.Length; i++) {
            if (s[i] != '(') {
                result.Append(s[i]);
                continue;
            }

            int start = ++i;
            while (s[i] != ')') {
                i++;
            }

            string key = s.Substring(start, i - start);
            if (values.TryGetValue(key, out string value)) {
                result.Append(value);
            } else {
                result.Append('?');
            }
        }

        return result.ToString();
    }
}