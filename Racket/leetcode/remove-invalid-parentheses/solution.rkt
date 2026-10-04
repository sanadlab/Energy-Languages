#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (remove-invalid-parentheses s)
  (-> string? (listof string?))
  (define (valid? st)
    (let loop ([chars (string->list st)] [cnt 0])
      (cond
        [(null? chars) (= cnt 0)]
        [(char=? (car chars) #\() (loop (cdr chars) (add1 cnt))]
        [(char=? (car chars) #\)) (if (= cnt 0) #f (loop (cdr chars) (sub1 cnt)))]
        [else (loop (cdr chars) cnt)])))
  (let loop ([level (set s)])
    (cond
      [(set-empty? level) (list "")]
      [else
       (define valids (filter valid? (set->list level)))
       (cond
         [(not (null? valids)) valids]
         [else
          (define nxt
            (for*/fold ([acc (set)])
                       ([st (in-set level)]
                        [i (in-range (string-length st))]
                        #:when (or (char=? (string-ref st i) #\()
                                   (char=? (string-ref st i) #\))))
              (set-add acc (string-append (substring st 0 i) (substring st (add1 i))))))
          (loop nxt)])])))

(provide (all-defined-out))
