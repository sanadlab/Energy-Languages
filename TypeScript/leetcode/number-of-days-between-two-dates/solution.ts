function daysBetweenDates(date1: string, date2: string): number {
    const a = daysFromCivil(date1);
    const b = daysFromCivil(date2);
    return Math.abs(a - b);
}

function daysFromCivil(s: string): number {
    const parts = String(s).split("-");
    const v = [0, 0, 0];
    for (let i = 0; i < 3 && i < parts.length; i++) {
        const n = parseInt(parts[i], 10);
        v[i] = Number.isNaN(n) ? 0 : n;
    }
    let y = v[0];
    const m = v[1];
    const d = v[2];
    y -= m <= 2 ? 1 : 0;
    const era = Math.floor(y / 400);
    const yoe = y - era * 400;
    const doy = Math.floor((153 * (m + (m > 2 ? -3 : 9)) + 2) / 5) + d - 1;
    const doe = yoe * 365 + Math.floor(yoe / 4) - Math.floor(yoe / 100) + doy;
    return era * 146097 + doe - 719468;
}
