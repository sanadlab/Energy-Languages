#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (average salary)
  (-> (listof exact-integer?) flonum?)
  (define n (length salary))
  (define mn (apply min salary))
  (define mx (apply max salary))
  (define total (apply + salary))
  (exact->inexact (/ (- total mn mx) (- n 2))))

(provide (all-defined-out))
