#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (max-total-fruits fruits startPos k)
  (-> (listof (listof exact-integer?)) exact-integer? exact-integer? exact-integer?)
  (define v (list->vector fruits))
  (define n (vector-length v))
  (define (pos idx) (first (vector-ref v idx)))
  (define (amt idx) (second (vector-ref v idx)))
  (define (cost pos-l pos-r)
    (cond
      [(<= pos-r startPos) (- startPos pos-l)]
      [(>= pos-l startPos) (- pos-r startPos)]
      [else (+ (- pos-r pos-l) (min (- startPos pos-l) (- pos-r startPos)))]))
  (define best 0)
  (define total 0)
  (define i 0)
  (for ([j (in-range n)])
    (set! total (+ total (amt j)))
    (let loop ()
      (when (and (<= i j) (> (cost (pos i) (pos j)) k))
        (set! total (- total (amt i)))
        (set! i (add1 i))
        (loop)))
    (when (and (<= i j) (> total best))
      (set! best total)))
  best)

(provide (all-defined-out))
