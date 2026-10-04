#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (is-match s p)
  (-> string? string? boolean?)
  (define m (string-length s))
  (define n (string-length p))
  (define W (add1 n))
  (define dp (make-vector (* (add1 m) W) #f))
  (define (dref i j) (vector-ref dp (+ (* i W) j)))
  (define (dset! i j v) (vector-set! dp (+ (* i W) j) v))
  (dset! 0 0 #t)
  ; initialize the first row: '*' can match an empty prefix
  (for ([j (in-range 1 (add1 n))])
    (when (char=? (string-ref p (sub1 j)) #\*)
      (dset! 0 j (dref 0 (sub1 j)))))
  (for ([i (in-range 1 (add1 m))])
    (for ([j (in-range 1 (add1 n))])
      (define pc (string-ref p (sub1 j)))
      (cond
        [(or (char=? pc (string-ref s (sub1 i))) (char=? pc #\?))
         (dset! i j (dref (sub1 i) (sub1 j)))]
        [(char=? pc #\*)
         (dset! i j (or (dref (sub1 i) j) (dref i (sub1 j))))])))
  (dref m n))

(provide (all-defined-out))
