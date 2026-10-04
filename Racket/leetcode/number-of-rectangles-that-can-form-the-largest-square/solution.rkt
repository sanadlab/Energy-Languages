#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (count-good-rectangles rectangles)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define-values (_max-len count)
    (for/fold ([max-len 0] [count 0])
              ([r (in-list rectangles)])
      (define side (min (car r) (cadr r)))
      (cond
        [(> side max-len) (values side 1)]
        [(= side max-len) (values max-len (+ count 1))]
        [else (values max-len count)])))
  count)

(provide (all-defined-out))
