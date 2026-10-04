#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (array-strings-are-equal word1 word2)
  (-> (listof string?) (listof string?) boolean?)
  (string=? (apply string-append word1) (apply string-append word2)))

(provide (all-defined-out))
