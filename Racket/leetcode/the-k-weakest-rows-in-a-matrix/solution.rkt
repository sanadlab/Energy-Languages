#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (k-weakest-rows mat k)
  (-> (listof (listof exact-integer?)) exact-integer? (listof exact-integer?))
  (define counts
    (for/list ([row (in-list mat)] [i (in-naturals)])
      (cons (for/sum ([x (in-list row)]) x) i)))
  (define sorted-counts
    (sort counts (lambda (p q)
                   (if (= (car p) (car q))
                       (< (cdr p) (cdr q))
                       (< (car p) (car q))))))
  (map cdr (take sorted-counts k)))

(provide (all-defined-out))
