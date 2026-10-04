#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (count-vowel-substrings word)
  (-> string? exact-integer?)
  (define v (list->vector (string->list word)))
  (define n (vector-length v))
  (define (vowel? c) (and (memv c '(#\a #\e #\i #\o #\u)) #t))
  (for/fold ([count 0]) ([i (in-range n)])
    (cond
      [(not (vowel? (vector-ref v i))) count]
      [else
       (let loop ([j i] [seen (seteqv)] [count count])
         (if (and (< j n) (vowel? (vector-ref v j)))
             (let ([seen2 (set-add seen (vector-ref v j))])
               (loop (+ j 1) seen2
                     (if (= (set-count seen2) 5) (+ count 1) count)))
             count))])))

(provide (all-defined-out))
