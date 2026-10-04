#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (can-partition-k-subsets nums k)
  (-> (listof exact-integer?) exact-integer? boolean?)
  (cond
    [(or (<= k 0) (< (length nums) k)) #f]
    [else
     (define total (apply + nums))
     (cond
       [(not (zero? (modulo total k))) #f]
       [else
        (define target (quotient total k))
        (define v (list->vector (sort nums >)))
        (cond
          [(> (vector-ref v 0) target) #f]
          [else
           (define n (vector-length v))
           (define used (make-vector n #f))
           (define (backtrack k cur start)
             (cond
               [(= k 0) #t]
               [(= cur target) (backtrack (- k 1) 0 0)]
               [else
                (let loop ([i start])
                  (cond
                    [(>= i n) #f]
                    [(or (vector-ref used i) (> (+ cur (vector-ref v i)) target))
                     (loop (add1 i))]
                    [else
                     (vector-set! used i #t)
                     (cond
                       [(backtrack k (+ cur (vector-ref v i)) (add1 i)) #t]
                       [else
                        (vector-set! used i #f)
                        (if (= cur 0) #f (loop (add1 i)))])]))]))
           (backtrack k 0 0)])])]))

(provide (all-defined-out))
