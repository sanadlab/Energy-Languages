#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (length-of-lis nums)
  (-> (listof exact-integer?) exact-integer?)
  (define arr (list->vector nums))
  (define n (vector-length arr))
  (define tails (make-vector n 0))
  (define size 0)
  (for ([x (in-vector arr)])
    ;; bisect-left in tails[0..size)
    (define i
      (let loop ([lo 0] [hi size])
        (if (< lo hi)
            (let ([mid (quotient (+ lo hi) 2)])
              (if (< (vector-ref tails mid) x)
                  (loop (add1 mid) hi)
                  (loop lo mid)))
            lo)))
    (vector-set! tails i x)
    (when (= i size) (set! size (add1 size))))
  size)

(provide (all-defined-out))
