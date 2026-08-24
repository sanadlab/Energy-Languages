typedef struct { char** words; int nwords; char* stream; int slen; int scap; } StreamChecker;
StreamChecker* streamCheckerCreate(char** words, int wordsSize) {
    StreamChecker* o = malloc(sizeof(StreamChecker));
    o->nwords = wordsSize;
    o->words = malloc(sizeof(char*) * wordsSize);
    for (int i = 0; i < wordsSize; i++) o->words[i] = strdup(words[i]);
    o->scap = 16; o->stream = malloc(o->scap); o->slen = 0;
    return o;
}
bool streamCheckerQuery(StreamChecker* obj, char letter) {
    if (obj->slen + 1 >= obj->scap) { obj->scap *= 2; obj->stream = realloc(obj->stream, obj->scap); }
    obj->stream[obj->slen++] = letter;
    for (int i = 0; i < obj->nwords; i++) {
        int wl = strlen(obj->words[i]);
        if (wl <= obj->slen && memcmp(obj->stream + obj->slen - wl, obj->words[i], wl) == 0) return true;
    }
    return false;
}
void streamCheckerFree(StreamChecker* obj) {
    for (int i = 0; i < obj->nwords; i++) free(obj->words[i]);
    free(obj->words); free(obj->stream); free(obj);
}
