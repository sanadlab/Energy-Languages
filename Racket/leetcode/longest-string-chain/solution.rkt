#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (longest-str-chain words)
  (-> (listof string?) exact-integer?)
  (define sorted (sort words < #:key string-length))
  (define dp (make-hash))
  (define best 1)
  (for ([w (in-list sorted)])
    (define len (string-length w))
    (define cur
      (for/fold ([cur 1]) ([i (in-range len)])
        (define pred (string-append (substring w 0 i) (substring w (add1 i))))
        (define v (hash-ref dp pred #f))
        (if v (max cur (add1 v)) cur)))
    (hash-set! dp w cur)
    (set! best (max best cur)))
  best)

(provide (all-defined-out))
