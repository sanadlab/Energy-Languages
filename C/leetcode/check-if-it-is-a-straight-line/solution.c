#include <stdbool.h>

bool checkStraightLine(int** coordinates, int coordinatesSize, int* coordinatesColSize) {
    long long dx = coordinates[1][0] - coordinates[0][0];
    long long dy = coordinates[1][1] - coordinates[0][1];
    for (int i = 2; i < coordinatesSize; i++) {
        long long x_diff = coordinates[i][0] - coordinates[0][0];
        long long y_diff = coordinates[i][1] - coordinates[0][1];
        if (dx * y_diff != dy * x_diff) {
            return false;
        }
    }
    return true;
}
