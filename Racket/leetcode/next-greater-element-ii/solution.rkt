#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (next-greater-elements nums)
  (-> (listof exact-integer?) (listof exact-integer?))
  (define nv (list->vector nums))
  (define n (vector-length nv))
  (define res (make-vector n -1))
  (let loop ([i 0] [st '()])
    (when (< i (* 2 n))
      (let ([cur (vector-ref nv (modulo i n))])
        (let pop ([st st])
          (if (and (pair? st) (< (vector-ref nv (car st)) cur))
              (begin (vector-set! res (car st) cur) (pop (cdr st)))
              (loop (+ i 1) (if (< i n) (cons i st) st)))))))
  (vector->list res))

(provide (all-defined-out))
