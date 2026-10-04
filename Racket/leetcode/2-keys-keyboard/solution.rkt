#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-steps n)
  (-> exact-integer? exact-integer?)
  (let loop ([n n] [res 0] [d 2])
    (cond
      [(<= n 1) res]
      [(= (modulo n d) 0) (loop (quotient n d) (+ res d) d)]
      [else (loop n res (+ d 1))])))

(provide (all-defined-out))
