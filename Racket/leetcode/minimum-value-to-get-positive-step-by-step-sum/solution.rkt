#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-start-value nums)
  (-> (listof exact-integer?) exact-integer?)
  (define-values (prefix min-prefix)
    (for/fold ([prefix 0] [min-prefix 0]) ([x (in-list nums)])
      (define np (+ prefix x))
      (values np (min min-prefix np))))
  (max 1 (- 1 min-prefix)))

(provide (all-defined-out))
