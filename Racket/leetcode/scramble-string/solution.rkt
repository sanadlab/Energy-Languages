#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (is-scramble s1 s2)
  (-> string? string? boolean?)
  (cond
    [(not (= (string-length s1) (string-length s2))) #f]
    [else
     (define n (string-length s1))
     (define v1 (list->vector (string->list s1)))
     (define v2 (list->vector (string->list s2)))
     (define (idx len i j) (+ (* len n n) (* i n) j))
     (define dp (make-vector (* (add1 n) n n) #f))
     (define (check-equal i1 i2 length)
       (equal? (sort (for/list ([t (in-range length)]) (vector-ref v1 (+ i1 t))) char<?)
               (sort (for/list ([t (in-range length)]) (vector-ref v2 (+ i2 t))) char<?)))
     (for ([length (in-range 1 (add1 n))])
       (for ([i (in-range (add1 (- n length)))])
         (for ([j (in-range (add1 (- n length)))])
           (when (check-equal i j length)
             (cond
               [(= length 1) (vector-set! dp (idx length i j) #t)]
               [else
                (let loop ([k 1])
                  (when (< k length)
                    (if (or (and (vector-ref dp (idx k i j))
                                 (vector-ref dp (idx (- length k) (+ i k) (+ j k))))
                            (and (vector-ref dp (idx k i (+ j (- length k))))
                                 (vector-ref dp (idx (- length k) (+ i k) j))))
                        (vector-set! dp (idx length i j) #t)
                        (loop (add1 k)))))])))))
     (vector-ref dp (idx n 0 0))]))

(provide (all-defined-out))
