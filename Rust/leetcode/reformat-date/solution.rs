impl Solution {
    pub fn reformat_date(date: String) -> String {
        let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
        let parts: Vec<&str> = date.split_whitespace().collect();
        if parts.len() < 3 {
            return String::new();
        }
        let d = parts[0];
        let mut day = if d.len() >= 2 { d[..d.len() - 2].to_string() } else { d.to_string() };
        if day.len() == 1 {
            day = format!("0{}", day);
        }
        let mut month = String::from("01");
        for (i, m) in months.iter().enumerate() {
            if *m == parts[1] {
                month = format!("{:02}", i + 1);
                break;
            }
        }
        format!("{}-{}-{}", parts[2], month, day)
    }
}
