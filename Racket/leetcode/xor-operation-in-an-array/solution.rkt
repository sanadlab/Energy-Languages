#lang racket
(require "../../../selection/nodes.rkt")
(define/contract (xor-operation n start)
  (-> exact-integer? exact-integer? exact-integer?)
  (for/fold ([acc 0]) ([i (in-range n)]) (bitwise-xor acc (+ start (* 2 i)))))
(provide (all-defined-out))
