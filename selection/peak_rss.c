/* peak_rss OUTFILE CMD [ARG...]
 *
 * Run CMD and write its peak resident set size (ru_maxrss from wait4, KB on
 * Linux, bytes on macOS) to OUTFILE. Exits with CMD's exit code, or 128+signal.
 *
 * Linux counts the memory a process held before exec in its ru_maxrss, and a
 * child starts as a copy of its parent. A program started directly from the
 * Python runner therefore reads at least the runner's own ~30 MB. This helper
 * is small, so the program it forks starts from about 1 MB.
 */
#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/wait.h>

int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "usage: peak_rss OUTFILE CMD [ARG...]\n");
        return 2;
    }
    /* Under memory pressure the kernel kills the solution, not the runner.
     * The child inherits the score. Fails silently where /proc is absent. */
    FILE *oom = fopen("/proc/self/oom_score_adj", "w");
    if (oom) {
        fputs("1000", oom);
        fclose(oom);
    }
    pid_t pid = fork();
    if (pid < 0) {
        perror("peak_rss: fork");
        return 2;
    }
    if (pid == 0) {
        execvp(argv[2], argv + 2);
        perror("peak_rss: exec");
        _exit(127);
    }
    int status;
    struct rusage ru;
    if (wait4(pid, &status, 0, &ru) < 0) {
        perror("peak_rss: wait4");
        return 2;
    }
    FILE *out = fopen(argv[1], "w");
    if (out) {
        fprintf(out, "%ld\n", ru.ru_maxrss);
        fclose(out);
    }
    if (WIFEXITED(status))
        return WEXITSTATUS(status);
    return 128 + WTERMSIG(status);
}
