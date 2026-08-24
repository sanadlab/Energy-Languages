typedef struct { int* buf; int n; int cap; int m; int k; } MKAverage;
MKAverage* mKAverageCreate(int m, int k) {
    MKAverage* o = malloc(sizeof(MKAverage));
    o->m = m; o->k = k; o->cap = 64; o->buf = malloc(sizeof(int) * o->cap); o->n = 0;
    return o;
}
void mKAverageAddElement(MKAverage* obj, int num) {
    if (obj->n == obj->cap) { obj->cap *= 2; obj->buf = realloc(obj->buf, sizeof(int) * obj->cap); }
    obj->buf[obj->n++] = num;
}
static int cmpint(const void* a, const void* b) { return (*(int*)a) - (*(int*)b); }
int mKAverageCalculateMKAverage(MKAverage* obj) {
    if (obj->n < obj->m) return -1;
    int* tmp = malloc(sizeof(int) * obj->m);
    memcpy(tmp, obj->buf + obj->n - obj->m, sizeof(int) * obj->m);
    qsort(tmp, obj->m, sizeof(int), cmpint);
    long long sum = 0;
    for (int i = obj->k; i < obj->m - obj->k; i++) sum += tmp[i];
    free(tmp);
    return (int)(sum / (obj->m - 2 * obj->k));
}
void mKAverageFree(MKAverage* obj) { free(obj->buf); free(obj); }
