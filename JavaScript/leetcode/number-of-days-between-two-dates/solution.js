/**
 * @param {string} date1
 * @param {string} date2
 * @return {number}
 */
var daysBetweenDates = function(date1, date2) {
    const p1 = parseDate(date1);
    const p2 = parseDate(date2);
    const a = daysFromCivil(p1[0], p1[1], p1[2]);
    const b = daysFromCivil(p2[0], p2[1], p2[2]);
    return Math.abs(a - b);
};

function parseDate(s) {
    const parts = String(s).split("-");
    const vals = [0, 0, 0];
    for (let i = 0; i < 3 && i < parts.length; i++) {
        const v = parseInt(parts[i], 10);
        vals[i] = Number.isNaN(v) ? 0 : v;
    }
    return vals;
}

function daysFromCivil(y, m, d) {
    y -= (m <= 2) ? 1 : 0;
    const era = Math.floor(y / 400);
    const yoe = y - era * 400;
    const doy = Math.floor((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + d - 1;
    const doe = yoe * 365 + Math.floor(yoe / 4) - Math.floor(yoe / 100) + doy;
    return era * 146097 + doe - 719468;
}
