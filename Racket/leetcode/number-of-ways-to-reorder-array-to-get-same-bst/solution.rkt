#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (num-of-ways nums)
  (-> (listof exact-integer?) exact-integer?)
  (define MOD 1000000007)
  (define n (length nums))
  (define C (make-vector (add1 n) #f))
  (for ([i (in-range (add1 n))])
    (define row (make-vector (add1 n) 0))
    (vector-set! row 0 1)
    (for ([j (in-range 1 (add1 i))])
      (vector-set! row j
        (modulo (+ (vector-ref (vector-ref C (sub1 i)) (sub1 j))
                   (vector-ref (vector-ref C (sub1 i)) j))
                MOD)))
    (vector-set! C i row))
  (define (ways arr)
    (define m (length arr))
    (cond
      [(<= m 2) 1]
      [else
       (define root (car arr))
       (define rest (cdr arr))
       (define left (filter (lambda (x) (< x root)) rest))
       (define right (filter (lambda (x) (> x root)) rest))
       (modulo (* (modulo (* (vector-ref (vector-ref C (sub1 m)) (length left))
                             (ways left))
                          MOD)
                  (ways right))
               MOD)]))
  (modulo (- (ways nums) 1) MOD))

(provide (all-defined-out))
