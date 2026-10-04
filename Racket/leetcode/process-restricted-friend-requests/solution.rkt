#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (friend-requests n restrictions requests)
  (-> exact-integer? (listof (listof exact-integer?)) (listof (listof exact-integer?)) (listof boolean?))
  (define parent (build-vector n values))
  (define (find x)
    (let loop ([x x])
      (if (= (vector-ref parent x) x)
          x
          (begin
            (vector-set! parent x (vector-ref parent (vector-ref parent x)))
            (loop (vector-ref parent x))))))
  (for/list ([req (in-list requests)])
    (define u (first req))
    (define v (second req))
    (define pu (find u))
    (define pv (find v))
    (cond
      [(= pu pv) #t]
      [else
       (define ok
         (for/and ([r (in-list restrictions)])
           (define px (find (first r)))
           (define py (find (second r)))
           (not (or (and (= px pu) (= py pv))
                    (and (= px pv) (= py pu))))))
       (cond
         [ok (vector-set! parent pu pv) #t]
         [else #f])])))

(provide (all-defined-out))
