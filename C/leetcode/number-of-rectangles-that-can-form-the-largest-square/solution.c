

int countGoodRectangles(int** rectangles, int rectanglesSize, int* rectanglesColSize){
    int max_len = 0, count = 0;
    for (int i = 0; i < rectanglesSize; i++) {
        int side = rectangles[i][0] < rectangles[i][1] ? rectangles[i][0] : rectangles[i][1];
        if (side > max_len) {
            max_len = side;
            count = 1;
        } else if (side == max_len) {
            count++;
        }
    }
    return count;
}
