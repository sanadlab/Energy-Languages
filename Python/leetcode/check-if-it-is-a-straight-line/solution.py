class Solution:
    def checkStraightLine(self, coordinates: List[List[int]]) -> bool:
        # Calculate the slope between the first two points
        dx = coordinates[1][0] - coordinates[0][0]
        dy = coordinates[1][1] - coordinates[0][1]
        
        for i in range(2, len(coordinates)):
            x_diff = coordinates[i][0] - coordinates[0][0]
            y_diff = coordinates[i][1] - coordinates[0][1]
            
            # Check if the cross product of (dx, dy) and (x_diff, y_diff) is zero
            if dx * y_diff != dy * x_diff:
                return False
        
        return True