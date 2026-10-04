#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (maximum-binary-string binary)
  (-> string? string?)
  (define n (string-length binary))
  (define first
    (let loop ([i 0])
      (cond [(>= i n) -1]
            [(char=? (string-ref binary i) #\0) i]
            [else (loop (+ i 1))])))
  (if (= first -1)
      binary
      (let ([zeros (for/sum ([ch (in-string binary)]) (if (char=? ch #\0) 1 0))]
            [res (make-string n #\1)])
        (string-set! res (+ first zeros -1) #\0)
        res)))

(provide (all-defined-out))
