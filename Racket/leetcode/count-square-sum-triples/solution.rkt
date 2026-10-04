#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (count-triples n)
  (-> exact-integer? exact-integer?)
  (for*/sum ([a (in-range 1 (add1 n))]
             [b (in-range a (add1 n))])
    (define c-square (+ (* a a) (* b b)))
    (define c (integer-sqrt c-square))
    (if (and (<= c n) (= (* c c) c-square)) 2 0)))

(provide (all-defined-out))
