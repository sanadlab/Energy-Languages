#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (num-factored-binary-trees arr)
  (-> (listof exact-integer?) exact-integer?)
  (define MOD 1000000007)
  (define vec (list->vector (sort arr <)))
  (define n (vector-length vec))
  (define dp (make-hash))
  (for ([i (in-range n)])
    (define v (vector-ref vec i))
    (define cnt
      (for/fold ([cnt 1]) ([j (in-range i)])
        (define a (vector-ref vec j))
        (if (zero? (modulo v a))
            (let ([b (quotient v a)])
              (if (hash-has-key? dp b)
                  (+ cnt (* (hash-ref dp a) (hash-ref dp b)))
                  cnt))
            cnt)))
    (hash-set! dp v (modulo cnt MOD)))
  (modulo (for/sum ([val (in-hash-values dp)]) val) MOD))

(provide (all-defined-out))
