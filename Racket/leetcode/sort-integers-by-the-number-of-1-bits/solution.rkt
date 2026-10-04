#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (sort-by-bits arr)
  (-> (listof exact-integer?) (listof exact-integer?))
  (define (popcount x)
    (let loop ([x x] [c 0])
      (if (= x 0) c (loop (arithmetic-shift x -1) (+ c (bitwise-and x 1))))))
  (define keyed (map (lambda (x) (cons (popcount x) x)) arr))
  (define sorted-keyed
    (sort keyed (lambda (p q)
                  (if (= (car p) (car q))
                      (< (cdr p) (cdr q))
                      (< (car p) (car q))))))
  (map cdr sorted-keyed))

(provide (all-defined-out))
