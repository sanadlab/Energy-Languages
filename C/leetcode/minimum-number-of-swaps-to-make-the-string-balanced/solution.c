int minSwaps(char* s) {
    int open_ = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        if (s[i] == '[') open_++;
        else if (open_ > 0) open_--;
    }
    return (open_ + 1) / 2;
}
