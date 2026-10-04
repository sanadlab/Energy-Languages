#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-subsequence nums)
  (-> (listof exact-integer?) (listof exact-integer?))
  (define sorted (sort nums >))
  (define total (apply + nums))
  (let loop ([lst sorted] [running 0] [res '()])
    (cond
      [(null? lst) (reverse res)]
      [else
       (define x (car lst))
       (define nr (+ running x))
       (define nres (cons x res))
       (if (> (* nr 2) total)
           (reverse nres)
           (loop (cdr lst) nr nres))])))

(provide (all-defined-out))
