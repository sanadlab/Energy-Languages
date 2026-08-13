/**
 * @param {number[][]} coordinates
 * @return {boolean}
 */
var checkStraightLine = function(coordinates) {
    const x0 = coordinates[0][0], y0 = coordinates[0][1];
    const dx = coordinates[1][0] - x0, dy = coordinates[1][1] - y0;
    for (let i = 2; i < coordinates.length; i++) {
        const cx = coordinates[i][0] - x0, cy = coordinates[i][1] - y0;
        if (dx * cy !== dy * cx) return false;
    }
    return true;
};
