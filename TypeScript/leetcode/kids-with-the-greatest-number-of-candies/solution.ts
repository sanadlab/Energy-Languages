function kidsWithCandies(candies: number[], extraCandies: number): boolean[] {
    const mx = Math.max(...candies);
    return candies.map(c => c + extraCandies >= mx);
}
