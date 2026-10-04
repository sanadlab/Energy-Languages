#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (license-key-formatting s k)
  (-> string? exact-integer? string?)
  (define cleaned (string-upcase (string-replace s "-" "")))
  (define len (string-length cleaned))
  (define first-group-len (modulo len k))
  (define groups
    (let loop ([i first-group-len]
               [acc (if (> first-group-len 0)
                        (list (substring cleaned 0 first-group-len))
                        '())])
      (if (< i len)
          (loop (+ i k) (cons (substring cleaned i (min (+ i k) len)) acc))
          (reverse acc))))
  (string-join groups "-"))

(provide (all-defined-out))
