#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (count-collisions directions)
  (-> string? exact-integer?)
  (define n (string-length directions))
  ; leading 'L' cars drive off to the left and never collide
  (define i
    (let loop ([i 0])
      (if (and (< i n) (char=? (string-ref directions i) #\L)) (loop (add1 i)) i)))
  ; trailing 'R' cars drive off to the right and never collide
  (define j
    (let loop ([j (sub1 n)])
      (if (and (>= j 0) (char=? (string-ref directions j) #\R)) (loop (sub1 j)) j)))
  ; every remaining moving car contributes exactly 1 collision
  (for/sum ([k (in-range i (add1 j))])
    (if (char=? (string-ref directions k) #\S) 0 1)))

(provide (all-defined-out))
