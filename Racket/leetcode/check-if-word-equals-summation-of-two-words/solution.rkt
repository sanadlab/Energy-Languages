#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (is-sum-equal firstWord secondWord targetWord)
  (-> string? string? string? boolean?)
  (define (word->num w)
    (for/fold ([num 0]) ([c (in-string w)])
      (+ (* num 10) (- (char->integer c) (char->integer #\a)))))
  (= (+ (word->num firstWord) (word->num secondWord)) (word->num targetWord)))

(provide (all-defined-out))
