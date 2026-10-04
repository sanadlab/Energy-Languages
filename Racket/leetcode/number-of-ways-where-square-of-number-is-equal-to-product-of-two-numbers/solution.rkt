#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (num-triplets nums1 nums2)
  (-> (listof exact-integer?) (listof exact-integer?) exact-integer?)
  (define (helper a b)
    (for/sum ([x (in-list a)])
      (define t (* x x))
      (define seen (make-hash))
      (for/sum ([y (in-list b)])
        (define add
          (if (= (modulo t y) 0)
              (hash-ref seen (quotient t y) 0)
              0))
        (hash-set! seen y (add1 (hash-ref seen y 0)))
        add)))
  (+ (helper nums1 nums2) (helper nums2 nums1)))

(provide (all-defined-out))
