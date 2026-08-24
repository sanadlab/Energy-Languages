typedef struct { int* stk; int* inc; int size; int maxSize; } CustomStack;
CustomStack* customStackCreate(int maxSize) {
    CustomStack* o = malloc(sizeof(CustomStack));
    o->stk = malloc(sizeof(int) * maxSize);
    o->inc = calloc(maxSize, sizeof(int));
    o->size = 0; o->maxSize = maxSize;
    return o;
}
void customStackPush(CustomStack* obj, int x) {
    if (obj->size < obj->maxSize) obj->stk[obj->size++] = x;
}
int customStackPop(CustomStack* obj) {
    if (obj->size == 0) return -1;
    int i = --obj->size;
    if (i > 0) obj->inc[i - 1] += obj->inc[i];
    int res = obj->stk[i] + obj->inc[i];
    obj->inc[i] = 0;
    return res;
}
void customStackIncrement(CustomStack* obj, int k, int val) {
    int lim = k < obj->size ? k : obj->size;
    if (lim > 0) obj->inc[lim - 1] += val;
}
void customStackFree(CustomStack* obj) { free(obj->stk); free(obj->inc); free(obj); }
