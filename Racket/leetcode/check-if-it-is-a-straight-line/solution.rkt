#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (check-straight-line coordinates)
  (-> (listof (listof exact-integer?)) boolean?)
  (define v (list->vector (map list->vector coordinates)))
  (define n (vector-length v))
  (define (x i) (vector-ref (vector-ref v i) 0))
  (define (y i) (vector-ref (vector-ref v i) 1))
  (define dx (- (x 1) (x 0)))
  (define dy (- (y 1) (y 0)))
  (for/and ([i (in-range 2 n)])
    (= (* dx (- (y i) (y 0))) (* dy (- (x i) (x 0))))))

(provide (all-defined-out))
