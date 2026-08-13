class Solution {

    /**
     * @param String $date
     * @return String
     */
    function reformatDate($date) {
        $months = ["Jan"=>"01","Feb"=>"02","Mar"=>"03","Apr"=>"04",
                   "May"=>"05","Jun"=>"06","Jul"=>"07","Aug"=>"08",
                   "Sep"=>"09","Oct"=>"10","Nov"=>"11","Dec"=>"12"];
        $parts = preg_split('/\s+/', trim($date));
        if (count($parts) < 3) return "";
        $day = strlen($parts[0]) >= 2 ? substr($parts[0], 0, -2) : $parts[0];
        if (strlen($day) == 1) $day = "0" . $day;
        $month = isset($months[$parts[1]]) ? $months[$parts[1]] : "01";
        return $parts[2] . "-" . $month . "-" . $day;
    }
}
