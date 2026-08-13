class Solution {
    countMaxOrSubsets(nums: number[]): number {
        const n = nums.length;
        const maxOr = nums.reduce((acc, num) => acc | num, 0);
        
        let count = 0;
        
        for (let mask = 1; mask < (1 << n); mask++) {
            let currentOr = 0;
            for (let i = 0; i < n; i++) {
                if (mask & (1 << i)) {
                    currentOr |= nums[i];
                }
            }
            if (currentOr === maxOr) {
                count++;
            }
        }
        
        return count;
    }
}