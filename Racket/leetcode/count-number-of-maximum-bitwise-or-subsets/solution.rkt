#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (count-max-or-subsets nums)
  (-> (listof exact-integer?) exact-integer?)
  (define v (list->vector nums))
  (define n (vector-length v))
  (define max-or (for/fold ([m 0]) ([x (in-vector v)]) (bitwise-ior m x)))
  (for/fold ([count 0]) ([mask (in-range 1 (arithmetic-shift 1 n))])
    (define cur
      (for/fold ([c 0]) ([i (in-range n)])
        (if (not (zero? (bitwise-and mask (arithmetic-shift 1 i))))
            (bitwise-ior c (vector-ref v i))
            c)))
    (if (= cur max-or) (add1 count) count)))

(provide (all-defined-out))
