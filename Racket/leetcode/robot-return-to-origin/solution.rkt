#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (judge-circle moves)
  (-> string? boolean?)
  (define-values (x y)
    (for/fold ([x 0] [y 0]) ([m (in-string moves)])
      (cond
        [(char=? m #\U) (values x (add1 y))]
        [(char=? m #\D) (values x (sub1 y))]
        [(char=? m #\R) (values (add1 x) y)]
        [(char=? m #\L) (values (sub1 x) y)]
        [else (values x y)])))
  (and (= x 0) (= y 0)))

(provide (all-defined-out))
