#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (kids-with-candies candies extraCandies)
  (-> (listof exact-integer?) exact-integer? (listof boolean?))
  (define max-candies (apply max candies))
  (for/list ([kid (in-list candies)])
    (>= (+ kid extraCandies) max-candies)))

(provide (all-defined-out))
