#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (uncommon-from-sentences s1 s2)
  (-> string? string? (listof string?))
  (define all-words (string-split (string-append s1 " " s2)))
  (define counts (make-hash))
  (for ([w (in-list all-words)]) (hash-update! counts w add1 0))
  (for/list ([w (in-list (hash-keys counts))] #:when (= (hash-ref counts w) 1)) w))

(provide (all-defined-out))
