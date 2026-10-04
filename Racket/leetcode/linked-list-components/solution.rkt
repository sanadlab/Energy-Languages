#lang racket
(require "../../../selection/nodes.rkt")

; Definition for singly-linked list:
#|

; val : integer?
; next : (or/c list-node? #f)
(struct list-node
  (val next) #:mutable #:transparent)

; constructor
(define (make-list-node [val 0])
  (list-node val #f))

|#

(define/contract (num-components head nums)
  (-> (or/c list-node? #f) (listof exact-integer?) exact-integer?)
  (define s (list->seteqv nums))
  (let loop ([head head] [prev #f] [count 0])
    (if (not head)
        count
        (let ([cur (set-member? s (list-node-val head))])
          (loop (list-node-next head)
                cur
                (if (and cur (not prev)) (add1 count) count))))))

(provide (all-defined-out))
