#lang racket
(require "../../../selection/nodes.rkt")
(define/contract (min-depth root)
  (-> (or/c tree-node? #f) exact-integer?)
  (if (not root) 0
      (let loop ([level (list root)] [depth 1])
        (if (for/or ([n (in-list level)])
              (and (not (tree-node-left n)) (not (tree-node-right n))))
            depth
            (loop (for*/list ([n (in-list level)]
                              [c (in-list (list (tree-node-left n) (tree-node-right n)))]
                              #:when c)
                    c)
                  (add1 depth))))))
(provide (all-defined-out))
