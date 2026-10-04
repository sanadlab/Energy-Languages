#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (shuffle nums n)
  (-> (listof exact-integer?) exact-integer? (listof exact-integer?))
  (define v (list->vector nums))
  (define m (quotient (vector-length v) 2))
  (let loop ([i 0] [acc '()])
    (if (>= i m)
        (reverse acc)
        (loop (add1 i)
              (cons (vector-ref v (+ i m)) (cons (vector-ref v i) acc))))))

(provide (all-defined-out))
