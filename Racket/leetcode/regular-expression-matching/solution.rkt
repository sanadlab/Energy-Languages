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
  (dset! m n #t)
  (for ([i (in-range m -1 -1)])
    (for ([j (in-range (sub1 n) -1 -1)])
      (define first
        (and (< i m)
             (or (char=? (string-ref p j) (string-ref s i))
                 (char=? (string-ref p j) #\.))))
      (if (and (< (add1 j) n) (char=? (string-ref p (add1 j)) #\*))
          (dset! i j (or (dref i (+ j 2)) (and first (dref (add1 i) j))))
          (dset! i j (and first (dref (add1 i) (add1 j)))))))
  (dref 0 0))

(provide (all-defined-out))
