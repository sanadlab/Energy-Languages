#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (max-run-time n batteries)
  (-> exact-integer? (listof exact-integer?) exact-integer?)
  (define total (for/sum ([b (in-list batteries)]) b))
  (let loop ([lo 0] [hi (quotient total n)])
    (if (< lo hi)
        (let* ([mid (quotient (+ lo hi 1) 2)]
               [avail (for/sum ([b (in-list batteries)]) (min b mid))])
          (if (>= avail (* n mid))
              (loop mid hi)
              (loop lo (- mid 1))))
        lo)))

(provide (all-defined-out))
