#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (clumsy n)
  (-> exact-integer? exact-integer?)
  (define-values (stack _op)
    (for/fold ([stack (list n)] [op 0])
              ([x (in-range (- n 1) 0 -1)])
      (define new-stack
        (cond
          [(= op 0) (cons (* (car stack) x) (cdr stack))]
          [(= op 1) (cons (quotient (car stack) x) (cdr stack))]
          [(= op 2) (cons x stack)]
          [else     (cons (- x) stack)]))
      (values new-stack (modulo (+ op 1) 4))))
  (apply + stack))

(provide (all-defined-out))
