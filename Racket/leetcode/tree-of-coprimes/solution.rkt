#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (get-coprimes nums edges)
  (-> (listof exact-integer?) (listof (listof exact-integer?)) (listof exact-integer?))
  (define nv (list->vector nums))
  (define n (vector-length nv))
  (cond
    [(= n 0) '()]
    [else
     (define ans (make-vector n -1))
     (define adj (make-vector n '()))
     (for ([e (in-list edges)])
       (when (>= (length e) 2)
         (define u (first e))
         (define v (second e))
         (when (and (<= 0 u) (< u n) (<= 0 v) (< v n))
           (vector-set! adj u (cons v (vector-ref adj u)))
           (vector-set! adj v (cons u (vector-ref adj v))))))
     ;; coprime values for each value 1..50
     (define coprime (make-vector 51 '()))
     (for ([a (in-range 1 51)])
       (vector-set! coprime a
                    (for/list ([b (in-range 1 51)] #:when (= (gcd a b) 1)) b)))
     ;; ancestor stacks indexed by VALUE
     (define depth-stack (make-vector 51 '()))
     (define node-stack (make-vector 51 '()))
     ;; iterative DFS with enter/exit markers; frame = (vector node parent depth processed?)
     (let loop ([stack (list (vector 0 -1 0 #f))])
       (unless (null? stack)
         (define frame (car stack))
         (define rest (cdr stack))
         (define node (vector-ref frame 0))
         (define parent (vector-ref frame 1))
         (define depth (vector-ref frame 2))
         (define processed (vector-ref frame 3))
         (define val (vector-ref nv node))
         (cond
           [processed
            (vector-set! depth-stack val (cdr (vector-ref depth-stack val)))
            (vector-set! node-stack val (cdr (vector-ref node-stack val)))
            (loop rest)]
           [else
            (define-values (best-depth best-node)
              (for/fold ([bd -1] [bn -1]) ([cv (in-list (vector-ref coprime val))])
                (define ds (vector-ref depth-stack cv))
                (if (and (pair? ds) (> (car ds) bd))
                    (values (car ds) (car (vector-ref node-stack cv)))
                    (values bd bn))))
            (vector-set! ans node best-node)
            (define with-exit (cons (vector node parent depth #t) rest))
            (vector-set! depth-stack val (cons depth (vector-ref depth-stack val)))
            (vector-set! node-stack val (cons node (vector-ref node-stack val)))
            (define pushed
              (for/fold ([s with-exit]) ([nb (in-list (vector-ref adj node))]
                                         #:when (not (= nb parent)))
                (cons (vector nb node (add1 depth) #f) s)))
            (loop pushed)])))
     (vector->list ans)]))

(provide (all-defined-out))
