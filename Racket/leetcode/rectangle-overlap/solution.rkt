#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (is-rectangle-overlap rec1 rec2)
  (-> (listof exact-integer?) (listof exact-integer?) boolean?)
  (and (< (list-ref rec1 0) (list-ref rec2 2))
       (< (list-ref rec2 0) (list-ref rec1 2))
       (< (list-ref rec1 1) (list-ref rec2 3))
       (< (list-ref rec2 1) (list-ref rec1 3))))

(provide (all-defined-out))
