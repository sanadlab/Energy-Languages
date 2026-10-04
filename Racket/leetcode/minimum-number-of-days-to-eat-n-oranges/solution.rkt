#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-days n)
  (-> exact-integer? exact-integer?)
  (define memo (make-hash))
  (define (solve x)
    (cond
      [(<= x 1) x]
      [(hash-has-key? memo x) (hash-ref memo x)]
      [else
       (define res
         (+ 1 (min (+ (modulo x 2) (solve (quotient x 2)))
                   (+ (modulo x 3) (solve (quotient x 3))))))
       (hash-set! memo x res)
       res]))
  (solve n))

(provide (all-defined-out))
