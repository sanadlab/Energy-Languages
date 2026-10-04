#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (validate-binary-tree-nodes n leftChild rightChild)
  (-> exact-integer? (listof exact-integer?) (listof exact-integer?) boolean?)
  (define left (list->vector leftChild))
  (define right (list->vector rightChild))
  (define m (min (vector-length left) (vector-length right)))
  (define indeg (make-vector n 0))
  (let/ec return
    (for ([i (in-range m)])
      (for ([c (in-list (list (vector-ref left i) (vector-ref right i)))])
        (unless (= c -1)
          (when (or (< c 0) (>= c n)) (return #f))
          (vector-set! indeg c (+ (vector-ref indeg c) 1))
          (when (> (vector-ref indeg c) 1) (return #f)))))
    (define root
      (for/fold ([root -1]) ([i (in-range n)])
        (if (= (vector-ref indeg i) 0)
            (if (not (= root -1)) (return #f) i)
            root)))
    (when (= root -1) (return #f))
    (define visited (make-vector n #f))
    (let loop ([stack (list root)] [count 0])
      (cond
        [(null? stack) (= count n)]
        [else
         (define node (car stack))
         (when (vector-ref visited node) (return #f))
         (vector-set! visited node #t)
         (define new-count (+ count 1))
         (define new-stack
           (if (< node m)
               (for/fold ([s (cdr stack)])
                         ([c (in-list (list (vector-ref left node) (vector-ref right node)))])
                 (if (= c -1) s (cons c s)))
               (cdr stack)))
         (loop new-stack new-count)]))))

(provide (all-defined-out))
