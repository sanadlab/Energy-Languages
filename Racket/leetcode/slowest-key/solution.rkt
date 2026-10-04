#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (slowest-key releaseTimes keysPressed)
  (-> (listof exact-integer?) string? string?)
  (define rt (list->vector releaseTimes))
  (define n (vector-length rt))
  (define best-idx 0)
  (define best-dur (vector-ref rt 0))
  (for ([i (in-range 1 n)])
    (define dur (- (vector-ref rt i) (vector-ref rt (sub1 i))))
    (when (or (> dur best-dur)
              (and (= dur best-dur)
                   (char>? (string-ref keysPressed i) (string-ref keysPressed best-idx))))
      (set! best-dur dur)
      (set! best-idx i)))
  (substring keysPressed best-idx (add1 best-idx)))

(provide (all-defined-out))
