#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (abbreviate-product left right)
  (-> exact-integer? exact-integer? string?)
  (define p (for/product ([i (in-range left (add1 right))]) i))
  (define-values (p2 c)
    (let loop ([p p] [c 0])
      (if (and (> p 0) (= (modulo p 10) 0))
          (loop (quotient p 10) (add1 c))
          (values p c))))
  (define s (number->string p2))
  (define len (string-length s))
  (if (<= len 10)
      (format "~ae~a" s c)
      (format "~a...~ae~a" (substring s 0 5) (substring s (- len 5)) c)))

(provide (all-defined-out))
