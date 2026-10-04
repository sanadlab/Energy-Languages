#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (regions-by-slashes grid)
  (-> (listof string?) exact-integer?)
  (define n (length grid))
  (define gv (list->vector grid))
  (define sz (* 4 n n))
  (define parent (build-vector sz values))
  (define (find x)
    (let loop ([x x])
      (if (not (= (vector-ref parent x) x))
          (begin
            (vector-set! parent x (vector-ref parent (vector-ref parent x)))
            (loop (vector-ref parent x)))
          x)))
  (define (union a b)
    (define ra (find a))
    (define rb (find b))
    (unless (= ra rb) (vector-set! parent ra rb)))
  (for ([r (in-range n)])
    (define row (vector-ref gv r))
    (define rowlen (string-length row))
    (for ([c (in-range n)])
      (define base (* 4 (+ (* r n) c)))
      (define top base)
      (define right (+ base 1))
      (define bottom (+ base 2))
      (define left (+ base 3))
      (define ch (if (< c rowlen) (string-ref row c) #\space))
      (cond
        [(char=? ch #\/) (union top left) (union right bottom)]
        [(char=? ch #\\) (union top right) (union left bottom)]
        [else (union top right) (union right bottom) (union bottom left)])
      (when (< (+ c 1) n) (union right (+ (* 4 (+ (* r n) c 1)) 3)))
      (when (< (+ r 1) n) (union bottom (* 4 (+ (* (+ r 1) n) c))))))
  (for/sum ([i (in-range sz)]) (if (= (find i) i) 1 0)))

(provide (all-defined-out))
