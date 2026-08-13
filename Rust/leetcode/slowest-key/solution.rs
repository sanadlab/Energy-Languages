impl Solution {
    pub fn slowest_key(release_times: Vec<i32>, keys_pressed: String) -> char {
        let keys: Vec<char> = keys_pressed.chars().collect();
        let mut best = keys[0];
        let mut best_dur = release_times[0];
        for i in 1..release_times.len() {
            let dur = release_times[i] - release_times[i - 1];
            if dur > best_dur || (dur == best_dur && keys[i] > best) {
                best_dur = dur;
                best = keys[i];
            }
        }
        best
    }
}
