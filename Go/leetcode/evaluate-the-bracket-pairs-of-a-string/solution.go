import "strings"

func evaluate(s string, knowledge [][]string) string {
	m := make(map[string]string)
	for _, kv := range knowledge {
		m[kv[0]] = kv[1]
	}
	var sb strings.Builder
	n := len(s)
	for i := 0; i < n; {
		if s[i] == '(' {
			j := i + 1
			for j < n && s[j] != ')' {
				j++
			}
			key := s[i+1 : j]
			if val, ok := m[key]; ok {
				sb.WriteString(val)
			} else {
				sb.WriteByte('?')
			}
			i = j + 1
		} else {
			sb.WriteByte(s[i])
			i++
		}
	}
	return sb.String()
}
