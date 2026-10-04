#lang racket
(require "../../../selection/nodes.rkt")
(define mk-average%
  (class object%
    (super-new)
    (init-field m k)
    (define stream '())
    (define n 0)
    (define/public (add-element num)
      (set! stream (cons num stream))
      (set! n (add1 n)))
    (define/public (calculate-mk-average)
      (if (< n m) -1
          (let* ([last-m (sort (take stream m) <)]
                 [trimmed (take (drop last-m k) (- m (* 2 k)))])
            (if (null? trimmed) 0 (quotient (apply + trimmed) (length trimmed))))))))
(provide (all-defined-out))
