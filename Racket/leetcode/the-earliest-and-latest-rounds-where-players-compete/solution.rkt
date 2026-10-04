#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (earliest-and-latest n firstPlayer secondPlayer)
  (-> exact-integer? exact-integer? exact-integer? (listof exact-integer?))
  (define (cart lists)
    (if (null? lists)
        (list '())
        (for*/list ([x (in-list (car lists))]
                    [rest (in-list (cart (cdr lists)))])
          (cons x rest))))
  (define memo (make-hash))
  (define (dp m f0 s0)
    (define f (min f0 s0))
    (define s (max f0 s0))
    (define key (list m f s))
    (cond
      [(hash-ref memo key #f) => values]
      [(= (+ f s) (+ m 1))
       (hash-set! memo key (cons 1 1))
       (cons 1 1)]
      [else
       (define new-m (quotient (+ m 1) 2))
       (define groups
         (let loop ([p 1] [acc '()])
           (if (> p (quotient m 2))
               (reverse acc)
               (let ([q (- (+ m 1) p)])
                 (cond
                   [(or (= f p) (= f q)) (loop (add1 p) (cons (list f) acc))]
                   [(or (= s p) (= s q)) (loop (add1 p) (cons (list s) acc))]
                   [else (loop (add1 p) (cons (list p q) acc))])))))
       (define groups2
         (if (odd? m)
             (append groups (list (list (quotient (+ m 1) 2))))
             groups))
       (define outcomes (make-hash))
       (for ([combo (in-list (cart groups2))])
         (define below-f (for/sum ([w (in-list combo)]) (if (< w f) 1 0)))
         (define below-s (for/sum ([w (in-list combo)]) (if (< w s) 1 0)))
         (hash-set! outcomes (cons (+ below-f 1) (+ below-s 1)) #t))
       (define-values (earliest latest)
         (for/fold ([earliest #f] [latest #f])
                   ([oc (in-list (hash-keys outcomes))])
           (define res (dp new-m (car oc) (cdr oc)))
           (define e (+ (car res) 1))
           (define l (+ (cdr res) 1))
           (values (if earliest (min earliest e) e)
                   (if latest (max latest l) l))))
       (define result (cons earliest latest))
       (hash-set! memo key result)
       result]))
  (define res (dp n firstPlayer secondPlayer))
  (list (car res) (cdr res)))

(provide (all-defined-out))
