#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (split-array nums k)
  (-> (listof exact-integer?) exact-integer? exact-integer?)
  (let loop ([lo (apply max nums)] [hi (apply + nums)])
    (if (< lo hi)
        (let ([mid (quotient (+ lo hi) 2)])
          (define-values (cnt cur)
            (for/fold ([cnt 1] [cur 0]) ([x (in-list nums)])
              (if (> (+ cur x) mid)
                  (values (add1 cnt) x)
                  (values cnt (+ cur x)))))
          (if (<= cnt k) (loop lo mid) (loop (add1 mid) hi)))
        lo)))

(provide (all-defined-out))
