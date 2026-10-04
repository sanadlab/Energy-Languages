#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (largest-magic-square grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define m (length grid))
  (define n (length (car grid)))
  (define g (list->vector (map list->vector grid)))
  ;; prefix sum matrices for rows and columns (as in the reference)
  (define row-sums (build-vector m (lambda (_) (make-vector (+ n 1) 0))))
  (define col-sums (build-vector m (lambda (_) (make-vector (+ n 1) 0))))
  (for ([i (in-range m)])
    (for ([j (in-range n)])
      (vector-set! (vector-ref row-sums i) (+ j 1)
                   (+ (vector-ref (vector-ref row-sums i) j) (vector-ref (vector-ref g i) j)))
      (vector-set! (vector-ref col-sums i) (+ j 1)
                   (+ (vector-ref (vector-ref col-sums i) j) (vector-ref (vector-ref g i) j)))))
  (define (cell r c) (vector-ref (vector-ref g r) c))
  (define (is-magic? r c k)
    (define total (for/sum ([j (in-range k)]) (cell (+ r k -1) (+ c j))))
    (and
     (for/and ([i (in-range k)])
       (define row-sum (for/sum ([j (in-range k)]) (cell (+ r i) (+ c j))))
       (define col-sum (for/sum ([j (in-range k)]) (cell (+ r j) (+ c i))))
       (and (= row-sum total) (= col-sum total)))
     (let ([diag1 (for/sum ([i (in-range k)]) (cell (+ r i) (+ c i)))]
           [diag2 (for/sum ([i (in-range k)]) (cell (+ r k -1 (- i)) (+ c i)))])
       (and (= diag1 total) (= diag2 total)))))
  (let loop ([k (min m n)])
    (if (< k 2)
        1
        (let ([found
               (for*/or ([i (in-range (+ (- m k) 1))]
                         [j (in-range (+ (- n k) 1))])
                 (and (is-magic? i j k) k))])
          (or found (loop (- k 1)))))))

(provide (all-defined-out))
