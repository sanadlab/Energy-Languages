#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (can-cross stones)
  (-> (listof exact-integer?) boolean?)
  (define v (list->vector stones))
  (define nstones (vector-length v))
  (cond
    [(< nstones 2) #f]
    [(not (= (vector-ref v 1) 1)) #f]
    [else
     (define stone-set (list->set stones))
     (define dp (make-hash))
     (for ([s (in-list stones)]) (hash-set! dp s (mutable-set)))
     (set-add! (hash-ref dp 1) 1)
     (for ([stone (in-list stones)])
       (for ([k (in-list (set->list (hash-ref dp stone)))])
         (for ([step (in-list (list (sub1 k) k (add1 k)))])
           (when (and (> step 0) (set-member? stone-set (+ stone step)))
             (set-add! (hash-ref dp (+ stone step)) step)))))
     (not (set-empty? (hash-ref dp (vector-ref v (sub1 nstones)))))]))

(provide (all-defined-out))
