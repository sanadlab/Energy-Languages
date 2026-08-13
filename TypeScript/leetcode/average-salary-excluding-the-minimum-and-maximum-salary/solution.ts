function average(salary: number[]): number {
    let mn = salary[0], mx = salary[0], sum = 0;
    for (const s of salary) { sum += s; if (s < mn) mn = s; if (s > mx) mx = s; }
    return (sum - mn - mx) / (salary.length - 2);
}
