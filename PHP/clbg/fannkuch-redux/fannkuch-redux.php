<?php
/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/

   PerfArena note: the original CLBG PHP entry is a multicore version that
   forks 2*ncpus workers and aggregates through raw shmop shared memory
   (ftok/pcntl/shmop). That path is non-deterministic across hosts: it
   depends on /proc/cpuinfo, on the shmop and pcntl extensions being
   built in, and on a race-free shared-memory aggregation. In the harness
   container it produced a wrong checksum. This single-threaded version is
   deterministic in any PHP build and prints the canonical output. Verified
   against the Python reference for N=7..11.
*/

$n = (int) $argv[1];
$p = range(0, $n - 1);   // current permutation
$s = range(0, $n - 1);   // permutation counters
$sign = 1;
$maxflips = 0;
$sum = 0;

while (true) {
   // count pancake flips on a copy of the current permutation
   $q = $p;
   $flips = 0;
   $qo = $q[0];
   while ($qo != 0) {
      for ($i = 0, $j = $qo; $i < $j; ++$i, --$j) {
         $t = $q[$i]; $q[$i] = $q[$j]; $q[$j] = $t;
      }
      ++$flips;
      $qo = $q[0];
   }
   if ($flips > $maxflips) $maxflips = $flips;
   $sum += $sign * $flips;

   // advance to the next permutation
   if ($sign == 1) {
      $t = $p[0]; $p[0] = $p[1]; $p[1] = $t;
      $sign = -1;
   } else {
      $t = $p[1]; $p[1] = $p[2]; $p[2] = $t;
      $sign = 1;
      for ($i = 2; ; ) {
         if ($s[$i] != 0) { --$s[$i]; break; }
         if ($i == $n - 1) {
            printf("%d\nPfannkuchen(%d) = %d\n", $sum, $n, $maxflips);
            exit(0);
         }
         $s[$i] = $i;
         $t = $p[0];
         for ($j = 0; $j <= $i; ++$j) $p[$j] = $p[$j + 1];
         $p[$i + 1] = $t;
         ++$i;
      }
   }
}
