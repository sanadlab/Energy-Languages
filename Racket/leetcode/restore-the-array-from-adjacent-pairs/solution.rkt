#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (restore-array adjacentPairs)
  (-> (listof (listof exact-integer?)) (listof exact-integer?))
  (define adj (make-hash))
  (define order '())
  (define (add! k val)
    (unless (hash-has-key? adj k)
      (set! order (cons k order)))
    (hash-set! adj k (cons val (hash-ref adj k '()))))
  (for ([p (in-list adjacentPairs)])
    (add! (first p) (second p))
    (add! (second p) (first p)))
  (define n (+ (length adjacentPairs) 1))
  (define ins-order (reverse order))
  (define start
    (let ([default (if (pair? adjacentPairs) (first (first adjacentPairs)) 0)])
      (let loop ([ks ins-order])
        (cond
          [(null? ks) default]
          [(= (length (hash-ref adj (car ks))) 1) (car ks)]
          [else (loop (cdr ks))]))))
  (let loop ([res (list start)] [prev start] [cur start] [has-prev #f] [cnt 1])
    (if (< cnt n)
        (let ([nxt (let find ([xs (hash-ref adj cur '())])
                     (cond
                       [(null? xs) #f]
                       [(or (not has-prev) (not (= (car xs) prev))) (car xs)]
                       [else (find (cdr xs))]))])
          (if (eq? nxt #f)
              (reverse res)
              (loop (cons nxt res) cur nxt #t (+ cnt 1))))
        (reverse res))))

(provide (all-defined-out))
