#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (k-length-apart nums k)
  (-> (listof exact-integer?) exact-integer? boolean?)
  (let loop ([lst nums] [i 0] [prev -1])
    (cond
      [(null? lst) #t]
      [(= (car lst) 1)
       (if (and (not (= prev -1)) (< (- i prev 1) k))
           #f
           (loop (cdr lst) (add1 i) i))]
      [else (loop (cdr lst) (add1 i) prev)])))

(provide (all-defined-out))
