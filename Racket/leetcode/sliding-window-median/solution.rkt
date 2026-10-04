#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (median-sliding-window nums k)
  (-> (listof exact-integer?) exact-integer? (listof flonum?))
  (define v (list->vector nums))
  (define n (vector-length v))
  (for/list ([i (in-range 0 (add1 (- n k)))])
    (define wv
      (list->vector
       (sort (for/list ([j (in-range i (+ i k))]) (vector-ref v j)) <)))
    (if (odd? k)
        (exact->inexact (vector-ref wv (quotient k 2)))
        (/ (exact->inexact (+ (vector-ref wv (sub1 (quotient k 2)))
                              (vector-ref wv (quotient k 2))))
           2.0))))

(provide (all-defined-out))
