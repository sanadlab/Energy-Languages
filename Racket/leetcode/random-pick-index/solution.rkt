#lang racket
(require "../../../selection/nodes.rkt")

(define solution%
  (class object%
    (super-new)

    ; nums : (listof exact-integer?)
    (init-field
      nums)

    (define vec (list->vector nums))

    ; pick : exact-integer? -> exact-integer?
    (define/public (pick target)
      (define count 0)
      (define res -1)
      (for ([i (in-range (vector-length vec))])
        (when (= (vector-ref vec i) target)
          (set! count (add1 count))
          (when (= (random count) 0)
            (set! res i))))
      res)))

;; Your solution% object will be instantiated and called as such:
;; (define obj (new solution% [nums nums]))
;; (define param_1 (send obj pick target))

(provide (all-defined-out))
