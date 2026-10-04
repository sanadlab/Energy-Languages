#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (ambiguous-coordinates s)
  (-> string? (listof string?))
  (define (make d)
    (define n (string-length d))
    (if (= n 1)
        (list d)
        (let ([base (if (char=? (string-ref d 0) #\0) '() (list d))])
          (append base
            (for*/list ([i (in-range 1 n)]
                        [l (in-value (substring d 0 i))]
                        [r (in-value (substring d i n))]
                        #:when (and (or (string=? l "0")
                                        (not (char=? (string-ref l 0) #\0)))
                                    (not (char=? (string-ref r (sub1 (string-length r))) #\0))))
              (string-append l "." r))))))
  (define digits (substring s 1 (sub1 (string-length s))))
  (define n (string-length digits))
  (for*/list ([i (in-range 1 n)]
              [a (in-list (make (substring digits 0 i)))]
              [b (in-list (make (substring digits i n)))])
    (string-append "(" a ", " b ")")))

(provide (all-defined-out))
