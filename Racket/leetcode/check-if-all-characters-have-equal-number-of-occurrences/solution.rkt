#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (are-occurrences-equal s)
  (-> string? boolean?)
  (define counts (make-hash))
  (for ([c (in-string s)])
    (hash-update! counts c add1 0))
  (= 1 (set-count (list->set (hash-values counts)))))

(provide (all-defined-out))
