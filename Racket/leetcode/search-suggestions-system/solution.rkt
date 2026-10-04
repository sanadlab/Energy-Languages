#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (suggested-products products searchWord)
  (-> (listof string?) string? (listof (listof string?)))
  (define sorted-products (sort products string<?))
  (define-values (suggestions _prefix)
    (for/fold ([suggestions '()] [prefix ""])
              ([ch (in-string searchWord)])
      (define new-prefix (string-append prefix (string ch)))
      (define matching
        (for/list ([p (in-list sorted-products)] #:when (string-prefix? p new-prefix)) p))
      (define top3 (if (> (length matching) 3) (take matching 3) matching))
      (values (cons top3 suggestions) new-prefix)))
  (reverse suggestions))

(provide (all-defined-out))
