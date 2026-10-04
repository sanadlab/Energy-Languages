#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (num-smaller-by-frequency queries words)
  (-> (listof string?) (listof string?) (listof exact-integer?))
  (define (f s)
    (define minc
      (for/fold ([m #f]) ([c (in-string s)])
        (if (or (not m) (char<? c m)) c m)))
    (for/sum ([c (in-string s)]) (if (char=? c minc) 1 0)))
  (define word-freqs (list->vector (sort (map f words) <)))
  (define nw (vector-length word-freqs))
  (define (lower-bound target)
    (let loop ([lo 0] [hi (sub1 nw)])
      (if (<= lo hi)
          (let ([mid (quotient (+ lo hi) 2)])
            (if (< (vector-ref word-freqs mid) target)
                (loop (add1 mid) hi)
                (loop lo (sub1 mid))))
          lo)))
  (for/list ([q (in-list queries)])
    (- nw (lower-bound (add1 (f q))))))

(provide (all-defined-out))
