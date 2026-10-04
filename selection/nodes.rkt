#lang racket/base
;; Shared node structs for Racket LeetCode cells + the perf harness/validator.
;; Matches LeetCode's Racket snippet definitions exactly (#f = empty).
;; solution.rkt requires this via "../../../selection/nodes.rkt"; the harness and
;; validator require it as "nodes.rkt" — the same file resolves to one module
;; instance, so tree-node?/list-node? predicates match across both sides.
(provide (all-defined-out))
(struct tree-node (val left right) #:mutable #:transparent)
(define (make-tree-node [val 0]) (tree-node val #f #f))
(struct list-node (val next) #:mutable #:transparent)
(define (make-list-node [val 0]) (list-node val #f))
