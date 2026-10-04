#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-operations s)
  (-> string? exact-integer?)
  (define n (string-length s))
  (define cnt
    (for/sum ([i (in-range n)])
      (define expected (if (even? i) #\0 #\1))
      (if (char=? (string-ref s i) expected) 0 1)))
  (min cnt (- n cnt)))

(provide (all-defined-out))
