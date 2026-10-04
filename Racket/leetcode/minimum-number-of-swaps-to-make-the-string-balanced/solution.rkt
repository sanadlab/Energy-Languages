#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-swaps s)
  (-> string? exact-integer?)
  (define open
    (for/fold ([open 0]) ([c (in-string s)])
      (cond
        [(char=? c #\[) (add1 open)]
        [(> open 0) (sub1 open)]
        [else open])))
  (quotient (add1 open) 2))

(provide (all-defined-out))
