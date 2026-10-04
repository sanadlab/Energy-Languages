#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (count-vowel-permutation n)
  (-> exact-integer? exact-integer?)
  (define MOD 1000000007)
  (define-values (a e i o u)
    (for/fold ([a 1] [e 1] [i 1] [o 1] [u 1])
              ([_ (in-range (sub1 n))])
      (values
       (modulo e MOD)
       (modulo (+ a i) MOD)
       (modulo (+ a e o u) MOD)
       (modulo (+ i u) MOD)
       (modulo a MOD))))
  (modulo (+ a e i o u) MOD))

(provide (all-defined-out))
