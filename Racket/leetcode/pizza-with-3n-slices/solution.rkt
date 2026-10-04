#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (max-size-slices slices)
  (-> (listof exact-integer?) exact-integer?)
  (define NEG -1000000000000000000)
  (define (best nums k)
    (define n (vector-length nums))
    (define dp (build-vector (add1 n) (lambda (_) (make-vector (add1 k) NEG))))
    (for ([i (in-range (add1 n))])
      (vector-set! (vector-ref dp i) 0 0))
    (for ([i (in-range 1 (add1 n))])
      (for ([j (in-range 1 (add1 k))])
        (define skip (vector-ref (vector-ref dp (sub1 i)) j))
        (define prev (if (>= i 2)
                         (vector-ref (vector-ref dp (- i 2)) (sub1 j))
                         (if (= j 1) 0 NEG)))
        (define take (+ prev (vector-ref nums (sub1 i))))
        (vector-set! (vector-ref dp i) j (max skip take))))
    (vector-ref (vector-ref dp n) k))
  (define total (length slices))
  (define k (quotient total 3))
  (if (= k 0)
      0
      (let* ([v (list->vector slices)]
             [n (vector-length v)]
             [a (for/vector ([i (in-range (sub1 n))]) (vector-ref v i))]
             [b (for/vector ([i (in-range 1 n)]) (vector-ref v i))])
        (max (best a k) (best b k)))))

(provide (all-defined-out))
