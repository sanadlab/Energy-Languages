import java.util.*;
import java.util.stream.*;
import java.math.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

class Solution {
    private final Map<Integer, List<Integer>> indices = new HashMap<>();
    private final Random random = new Random();

    public Solution(int[] nums) {
        for (int i = 0; i < nums.length; i++) {
            indices.computeIfAbsent(nums[i], key -> new ArrayList<>()).add(i);
        }
    }

    public int pick(int target) {
        List<Integer> matches = indices.get(target);
        return matches.get(random.nextInt(matches.size()));
    }
}