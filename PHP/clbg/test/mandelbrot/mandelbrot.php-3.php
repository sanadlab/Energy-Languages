<?php
/*
   The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/

   contributed by Thomas GODART (based on Greg Buchholz's C program)

   PerfArena note: the original CLBG PHP entry is multicore (fork + shmop
   shared memory keyed by ftok(__FILE__, time())). That path scrambles row
   order across hosts and needs the shmop/pcntl extensions, and its "?>"
   trailer emitted one spurious byte. This single-threaded version uses the
   same escape arithmetic, so it reproduces the exact CLBG bitmap (byte for
   byte the per-language reference) in any PHP build. No closing "?>" tag,
   so no trailing byte leaks into the binary PBM.
*/

$h = (int) (($argc == 2) ? $argv[1] : 600);
$w = $h;

if ($w % 8) {
   fprintf(STDERR, "width %d not multiple of 8\n", $w);
   exit(1);
}

printf("P4\n%d %d\n", $w, $h);

$yfac = 2.0 / $h;
$xfac = 2.0 / $w;

$bit_num = 128;
$byte_acc = 0;
$out = '';

for ($y = 0; $y < $h; ++$y) {
   $Ci = $y * $yfac - 1.0;
   for ($x = 0; $x < $w; ++$x) {
      $Zr = 0; $Zi = 0; $Tr = 0; $Ti = 0.0;
      $Cr = $x * $xfac - 1.5;
      do {
         for ($i = 0; $i < 50; ++$i) {
            $Zi = 2.0 * $Zr * $Zi + $Ci;
            $Zr = $Tr - $Ti + $Cr;
            $Tr = $Zr * $Zr;
            if (($Tr + ($Ti = $Zi * $Zi)) > 4.0) break 2;
         }
         $byte_acc += $bit_num;
      } while (FALSE);

      if ($bit_num === 1) {
         $out .= chr($byte_acc);
         $bit_num = 128;
         $byte_acc = 0;
      } else {
         $bit_num >>= 1;
      }
   }
   if ($bit_num !== 128) {
      $out .= chr($byte_acc);
      $bit_num = 128;
      $byte_acc = 0;
   }
}

echo $out;
