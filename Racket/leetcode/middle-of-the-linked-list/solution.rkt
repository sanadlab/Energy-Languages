#lang racket
(require "../../../selection/nodes.rkt")
(define/contract (middle-node head)
  (-> (or/c list-node? #f) (or/c list-node? #f))
  (let loop ([slow head] [fast head])
    (cond
      [(not fast) slow]
      [(not (list-node-next fast)) slow]
      [else (loop (list-node-next slow) (list-node-next (list-node-next fast)))])))
(provide (all-defined-out))
