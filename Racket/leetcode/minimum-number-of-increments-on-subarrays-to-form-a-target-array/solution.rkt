#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-number-operations target)
  (-> (listof exact-integer?) exact-integer?)
  (cond
    [(null? target) 0]
    [else
     (define-values (ans _prev)
       (for/fold ([ans (car target)] [prev (car target)])
                 ([x (in-list (cdr target))])
         (values (if (> x prev) (+ ans (- x prev)) ans) x)))
     ans]))

(provide (all-defined-out))
