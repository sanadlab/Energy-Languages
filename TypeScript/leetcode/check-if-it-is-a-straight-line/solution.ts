class Solution {
    checkStraightLine(coordinates: number[][]): boolean {
        if (coordinates.length === 2) {
            return true;
        }
        
        const [x0, y0] = coordinates[0];
        const [x1, y1] = coordinates[1];
        
        for (let i = 2; i < coordinates.length; i++) {
            const [x, y] = coordinates[i];
            const crossProduct = (x1 - x0) * (y - y0) - (y1 - y0) * (x - x0);
            if (crossProduct !== 0) {
                return false;
            }
        }
        
        return true;
    }
}