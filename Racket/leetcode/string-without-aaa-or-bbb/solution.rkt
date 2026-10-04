#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (str-without3a3b a b)
  (-> exact-integer? exact-integer? string?)
  ; rev holds the chosen chars in reverse order; (car rev) is the last appended.
  (let loop ([a a] [b b] [rev '()])
    (cond
      [(and (<= a 0) (<= b 0)) (list->string (reverse rev))]
      [else
       (define write-a
         (if (and (pair? rev) (pair? (cdr rev)) (char=? (car rev) (cadr rev)))
             (char=? (car rev) #\b)
             (>= a b)))
       (cond
         [write-a
          (if (= a 0)
              (list->string (reverse rev))
              (loop (sub1 a) b (cons #\a rev)))]
         [else
          (if (= b 0)
              (list->string (reverse rev))
              (loop a (sub1 b) (cons #\b rev)))])])))

(provide (all-defined-out))
