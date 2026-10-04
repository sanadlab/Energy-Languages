#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (can-be-typed-words text brokenLetters)
  (-> string? string? exact-integer?)
  (define broken (list->set (string->list brokenLetters)))
  (for/sum ([word (in-list (string-split text))])
    (if (for/or ([c (in-string word)]) (set-member? broken c)) 0 1)))

(provide (all-defined-out))
