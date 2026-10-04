#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (next-beautiful-number n)
  (-> exact-integer? exact-integer?)
  (let loop ([x (add1 n)])
    (define cnt (make-vector 10 0))
    (let dcount ([t x])
      (when (> t 0)
        (define d (modulo t 10))
        (vector-set! cnt d (add1 (vector-ref cnt d)))
        (dcount (quotient t 10))))
    (define ok
      (for/and ([d (in-range 10)])
        (or (= (vector-ref cnt d) 0) (= (vector-ref cnt d) d))))
    (if ok x (loop (add1 x)))))

(provide (all-defined-out))
