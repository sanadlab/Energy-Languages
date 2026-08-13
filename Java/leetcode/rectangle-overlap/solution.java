class Solution {
    public boolean isRectangleOverlap(int[] rec1, int[] rec2) {
        // Check if one rectangle is to the left of the other
        if (rec1[2] <= rec2[0] || rec2[2] <= rec1[0]) return false;
        
        // Check if one rectangle is above the other
        if (rec1[3] <= rec2[1] || rec2[3] <= rec1[1]) return false;
        
        return true;
    }
}