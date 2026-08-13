var kidsWithCandies = function(candies, extraCandies) {
    const mx = Math.max(...candies);
    return candies.map(c => c + extraCandies >= mx);
};
