#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (find-k-distant-indices nums key k)
  (-> (listof exact-integer?) exact-integer? exact-integer? (listof exact-integer?))
  (define v (list->vector nums))
  (define n (vector-length v))
  (for/list ([i (in-range n)]
             #:when (for/or ([j (in-range n)])
                      (and (<= (abs (- i j)) k)
                           (= (vector-ref v j) key))))
    i))

(provide (all-defined-out))
