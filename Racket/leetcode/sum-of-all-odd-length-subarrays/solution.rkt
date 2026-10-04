#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (sum-odd-length-subarrays arr)
  (-> (listof exact-integer?) exact-integer?)
  (define v (list->vector arr))
  (define n (vector-length v))
  (for/sum ([i (in-range n)])
    (define count (quotient (+ (* (+ i 1) (- n i)) 1) 2))
    (* count (vector-ref v i))))

(provide (all-defined-out))
