#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (maximum-beauty flowers newFlowers target full partial)
  (-> (listof exact-integer?) exact-integer? exact-integer? exact-integer? exact-integer? exact-integer?)
  (define n (length flowers))
  (cond
    [(= n 0) 0]
    [else
     (define fl (list->vector (sort (map (lambda (f) (min f target)) flowers) <)))
     (define pre (make-vector (+ n 1) 0))
     (for ([i (in-range n)])
       (vector-set! pre (+ i 1) (+ (vector-ref pre i) (vector-ref fl i))))
     (cond
       [(= (vector-ref fl 0) target) (* full n)]
       [else
        ;; leftmost index in [0,end) with fl[idx] >= v  (bisect_left)
        (define (bisect-left v end)
          (let loop ([lo 0] [hi end])
            (if (< lo hi)
                (let ([mid (quotient (+ lo hi) 2)])
                  (if (< (vector-ref fl mid) v)
                      (loop (+ mid 1) hi)
                      (loop lo mid)))
                lo)))
        (for/fold ([ans 0]) ([i (in-range n -1 -1)])
          (define cost-complete (- (* target (- n i)) (- (vector-ref pre n) (vector-ref pre i))))
          (cond
            [(> cost-complete newFlowers) ans]
            [else
             (define rem (- newFlowers cost-complete))
             (cond
               [(= i 0) (max ans (* full (- n i)))]
               [else
                (define best-min
                  (let loop ([lo 0] [hi (- target 1)] [best 0])
                    (if (<= lo hi)
                        (let* ([v (quotient (+ lo hi) 2)]
                               [k (bisect-left v i)]
                               [cost (- (* v k) (vector-ref pre k))])
                          (if (<= cost rem)
                              (loop (+ v 1) hi v)
                              (loop lo (- v 1) best)))
                        best)))
                (max ans (+ (* full (- n i)) (* best-min partial)))])]))])]))

(provide (all-defined-out))
