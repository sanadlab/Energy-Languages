#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (remove-palindrome-sub s)
  (-> string? exact-integer?)
  (cond
    [(= 0 (string-length s)) 0]
    [(string=? s (list->string (reverse (string->list s)))) 1]
    [else 2]))

(provide (all-defined-out))
