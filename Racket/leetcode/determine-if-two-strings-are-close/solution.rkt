#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (close-strings word1 word2)
  (-> string? string? boolean?)
  (cond
    [(not (= (string-length word1) (string-length word2))) #f]
    [else
     (define f1 (make-vector 26 0))
     (define f2 (make-vector 26 0))
     (define a0 (char->integer #\a))
     (for ([c1 (in-string word1)] [c2 (in-string word2)])
       (define i1 (- (char->integer c1) a0))
       (define i2 (- (char->integer c2) a0))
       (vector-set! f1 i1 (add1 (vector-ref f1 i1)))
       (vector-set! f2 i2 (add1 (vector-ref f2 i2))))
     (cond
       [(for/or ([i (in-range 26)])
          (or (and (> (vector-ref f1 i) 0) (= (vector-ref f2 i) 0))
              (and (> (vector-ref f2 i) 0) (= (vector-ref f1 i) 0))))
        #f]
       [else
        (equal? (sort (vector->list f1) <) (sort (vector->list f2) <))])]))

(provide (all-defined-out))
