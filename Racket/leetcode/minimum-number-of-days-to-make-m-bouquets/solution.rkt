#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-days bloomDay m k)
  (-> (listof exact-integer?) exact-integer? exact-integer? exact-integer?)
  (define vb (list->vector bloomDay))
  (define len (vector-length vb))
  (if (> (* m k) len)
      -1
      (let ()
        (define (can-make day)
          (let loop ([idx 0] [bouquets 0] [flowers 0])
            (cond
              [(= idx len) (>= bouquets m)]
              [else
               (define b (vector-ref vb idx))
               (if (<= b day)
                   (let ([f (add1 flowers)])
                     (if (= f k)
                         (loop (add1 idx) (add1 bouquets) 0)
                         (loop (add1 idx) bouquets f)))
                   (loop (add1 idx) bouquets 0))])))
        (let loop ([lo (apply min bloomDay)] [hi (apply max bloomDay)])
          (if (< lo hi)
              (let ([mid (quotient (+ lo hi) 2)])
                (if (can-make mid) (loop lo mid) (loop (add1 mid) hi)))
              lo)))))

(provide (all-defined-out))
