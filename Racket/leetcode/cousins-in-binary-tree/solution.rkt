#lang racket
(require "../../../selection/nodes.rkt")

; Definition for a binary tree node.
#|

; val : integer?
; left : (or/c tree-node? #f)
; right : (or/c tree-node? #f)
(struct tree-node
  (val left right) #:mutable #:transparent)

; constructor
(define (make-tree-node [val 0])
  (tree-node val #f #f))

|#

(define/contract (is-cousins root x y)
  (-> (or/c tree-node? #f) exact-integer? exact-integer? boolean?)
  (define dx -1) (define dy -1) (define px #f) (define py #f)
  (let dfs ([node root] [parent #f] [depth 0])
    (when node
      (when (= (tree-node-val node) x) (set! dx depth) (set! px parent))
      (when (= (tree-node-val node) y) (set! dy depth) (set! py parent))
      (dfs (tree-node-left node) node (add1 depth))
      (dfs (tree-node-right node) node (add1 depth))))
  (and (= dx dy) (not (eq? px py))))

(provide (all-defined-out))
