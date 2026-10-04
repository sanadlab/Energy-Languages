#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (evaluate s knowledge)
  (-> string? (listof (listof string?)) string?)
  (define dict
    (for/hash ([pair (in-list knowledge)])
      (values (first pair) (second pair))))
  (let loop ([chars (string->list s)] [stack '()] [word ""])
    (cond
      [(null? chars) word]
      [else
       (define ch (car chars))
       (cond
         [(char=? ch #\()
          (loop (cdr chars) (cons word stack) "")]
         [(char=? ch #\))
          (define prev (string-append (car stack) (hash-ref dict word "?")))
          (loop (cdr chars) (cdr stack) prev)]
         [else
          (loop (cdr chars) stack (string-append word (string ch)))])])))

(provide (all-defined-out))
