#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (max-equal-freq nums)
  (-> (listof exact-integer?) exact-integer?)
  (define numsv (list->vector nums))
  (define n (vector-length numsv))
  (define count (make-hash))            ; value -> occurrence count
  (define freq (make-vector (add1 n) 0)) ; occurrence-count -> how many values have it
  (define maxF 0)
  (define res 0)
  (for ([i (in-range n)])
    (define v (vector-ref numsv i))
    (define cv (hash-ref count v 0))
    (when (> cv 0)
      (vector-set! freq cv (sub1 (vector-ref freq cv))))
    (define ncv (add1 cv))
    (hash-set! count v ncv)
    (vector-set! freq ncv (add1 (vector-ref freq ncv)))
    (when (> ncv maxF) (set! maxF ncv))
    (when (or (= maxF 1)
              (= (* (vector-ref freq maxF) maxF) i)
              (and (= (vector-ref freq maxF) 1)
                   (= (* (sub1 maxF) (add1 (vector-ref freq (sub1 maxF)))) i)))
      (set! res (add1 i))))
  res)

(provide (all-defined-out))
