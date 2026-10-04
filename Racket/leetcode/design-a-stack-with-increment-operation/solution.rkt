#lang racket
(require "../../../selection/nodes.rkt")

(define custom-stack%
  (class object%
    (super-new)

    ; max-size : exact-integer?
    (init-field
      max-size)

    (field [stk (make-vector (max 0 max-size) 0)]
           [inc (make-vector (max 0 max-size) 0)]
           [sz 0])

    ; push : exact-integer? -> void?
    (define/public (push x)
      (when (< sz max-size)
        (vector-set! stk sz x)
        (vector-set! inc sz 0)
        (set! sz (+ sz 1))))
    ; pop : -> exact-integer?
    (define/public (pop)
      (if (= sz 0)
          -1
          (let ([i (- sz 1)])
            (define v (+ (vector-ref stk i) (vector-ref inc i)))
            (when (> i 0)
              (vector-set! inc (- i 1) (+ (vector-ref inc (- i 1)) (vector-ref inc i))))
            (set! sz (- sz 1))
            v)))
    ; increment : exact-integer? exact-integer? -> void?
    (define/public (increment k val)
      (let ([i (- (min k sz) 1)])
        (when (>= i 0)
          (vector-set! inc i (+ (vector-ref inc i) val)))))))

;; Your custom-stack% object will be instantiated and called as such:
;; (define obj (new custom-stack% [max-size max-size]))
;; (send obj push x)
;; (define param_2 (send obj pop))
;; (send obj increment k val)

(provide (all-defined-out))
