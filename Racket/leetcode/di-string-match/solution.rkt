#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (di-string-match s)
  (-> string? (listof exact-integer?))
  (define len (string-length s))
  (let loop ([chars (string->list s)] [low 0] [high len] [acc '()])
    (cond
      [(null? chars) (reverse (cons low acc))]
      [(char=? (car chars) #\I) (loop (cdr chars) (add1 low) high (cons low acc))]
      [else (loop (cdr chars) low (sub1 high) (cons high acc))])))

(provide (all-defined-out))
