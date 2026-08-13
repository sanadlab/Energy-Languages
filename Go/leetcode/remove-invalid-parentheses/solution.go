func removeInvalidParentheses(s string) []string {
    valid := func(st string) bool {
        cnt := 0
        for i := 0; i < len(st); i++ {
            if st[i] == '(' {
                cnt++
            } else if st[i] == ')' {
                cnt--
                if cnt < 0 {
                    return false
                }
            }
        }
        return cnt == 0
    }
    level := map[string]bool{s: true}
    for len(level) > 0 {
        var valids []string
        for st := range level {
            if valid(st) {
                valids = append(valids, st)
            }
        }
        if len(valids) > 0 {
            return valids
        }
        nxt := make(map[string]bool)
        for st := range level {
            for i := 0; i < len(st); i++ {
                if st[i] == '(' || st[i] == ')' {
                    nxt[st[:i]+st[i+1:]] = true
                }
            }
        }
        level = nxt
    }
    return []string{""}
}
