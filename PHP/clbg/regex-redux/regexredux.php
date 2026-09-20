<?php
/* The Computer Language Benchmarks Game
   http://benchmarksgame.alioth.debian.org/

   regex-dna program contributed by Danny Sauer, modified by Josh Goldfoot,
   Sergey Khripunov, Craig Russell.

   PerfArena note: the original CLBG PHP entry is multicore (pcntl_fork plus a
   System V message queue via ftok/msg_get_queue/msg_send). That path is
   non-deterministic across hosts and needs the sysvmsg + pcntl extensions. It
   also counted with the case-insensitive /i flag while the benchmark is
   case-sensitive. This single-threaded version is deterministic in any PHP
   build and matches the CLBG reference output. Verified against the golden
   reference (`make validate`).
*/

$variants = array(
    'agggtaaa|tttaccct',
    '[cgt]gggtaaa|tttaccc[acg]',
    'a[act]ggtaaa|tttacc[agt]t',
    'ag[act]gtaaa|tttac[agt]ct',
    'agg[act]taaa|ttta[agt]cct',
    'aggg[acg]aaa|ttt[cgt]ccct',
    'agggt[cgt]aa|tt[acg]accct',
    'agggta[cgt]a|t[acg]taccct',
    'agggtaa[cgt]|[acg]ttaccct',
);

// IUB replacement parallel arrays (applied in this exact order).
$IUB = array();                 $IUBnew = array();
$IUB[]='/tHa[Nt]/S';            $IUBnew[]='<4>';
$IUB[]='/aND|caN|Ha[DS]|WaS/S'; $IUBnew[]='<3>';
$IUB[]='/a[NSt]|BY/S';          $IUBnew[]='<2>';
$IUB[]='/<[^>]*>/S';            $IUBnew[]='|';
$IUB[]='/\\|[^|][^|]*\\|/S';    $IUBnew[]='-';

$contents = file_get_contents('php://stdin');
$initialLength = strlen($contents);

// strip FASTA headers and newlines
$contents = preg_replace('/^>.*$|\n/mS', '', $contents);
$codeLength = strlen($contents);

// count each variant (case-sensitive), in order
foreach ($variants as $regex) {
    echo $regex, ' ', preg_match_all('/' . $regex . '/S', $contents), "\n";
}

// apply the substitutions, in order
$contents = preg_replace($IUB, $IUBnew, $contents);

echo "\n",
      $initialLength, "\n",
      $codeLength, "\n",
      strlen($contents), "\n";
