#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (max-sum-two-no-overlap nums firstLen secondLen)
  (-> (listof exact-integer?) exact-integer? exact-integer? exact-integer?)
  (define vnums (list->vector nums))
  (define n (vector-length vnums))
  (define pre (make-vector (add1 n) 0))
  (for ([i (in-range n)])
    (vector-set! pre (add1 i) (+ (vector-ref pre i) (vector-ref vnums i))))
  (define (best L M)
    (for/fold ([res 0] [maxL 0] #:result res) ([i (in-range (+ L M) (add1 n))])
      (define nmaxL (max maxL (- (vector-ref pre (- i M)) (vector-ref pre (- i M L)))))
      (values (max res (+ nmaxL (- (vector-ref pre i) (vector-ref pre (- i M))))) nmaxL)))
  (max (best firstLen secondLen) (best secondLen firstLen)))

(provide (all-defined-out))
