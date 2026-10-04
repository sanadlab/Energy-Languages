#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (shift-grid grid k)
  (-> (listof (listof exact-integer?)) exact-integer? (listof (listof exact-integer?)))
  (define m (length grid))
  (cond
    [(= m 0) grid]
    [else
     (define n (length (car grid)))
     (cond
       [(= n 0) grid]
       [else
        (define total (* m n))
        (define kk (modulo k total))
        (define flat (list->vector (append* grid)))
        (define res (build-vector m (lambda (_) (make-vector n 0))))
        (for ([idx (in-range total)])
          (define np (modulo (+ idx kk) total))
          (vector-set! (vector-ref res (quotient np n)) (modulo np n) (vector-ref flat idx)))
        (for/list ([rowv (in-vector res)]) (vector->list rowv))])]))

(provide (all-defined-out))
