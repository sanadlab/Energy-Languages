#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (min-days grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define rows (length grid))
  (define cols (length (car grid)))
  (define g (list->vector (map list->vector grid)))
  (define (gref i j) (vector-ref (vector-ref g i) j))
  (define (gset! i j val) (vector-set! (vector-ref g i) j val))
  (define (count-islands)
    (define visited (build-vector rows (lambda (_) (make-vector cols #f))))
    (define (vref i j) (vector-ref (vector-ref visited i) j))
    (define (vset! i j) (vector-set! (vector-ref visited i) j #t))
    (for*/fold ([count 0]) ([i (in-range rows)] [j (in-range cols)])
      (cond
        [(and (= (gref i j) 1) (not (vref i j)))
         (vset! i j)
         (let loop ([stack (list (cons i j))])
           (unless (null? stack)
             (define xy (car stack))
             (define x (car xy))
             (define y (cdr xy))
             (define rest (cdr stack))
             (define newstack
               (for/fold ([st rest]) ([d (in-list '((1 . 0) (-1 . 0) (0 . 1) (0 . -1)))])
                 (define nx (+ x (car d)))
                 (define ny (+ y (cdr d)))
                 (if (and (<= 0 nx) (< nx rows) (<= 0 ny) (< ny cols)
                          (= (gref nx ny) 1) (not (vref nx ny)))
                     (begin (vset! nx ny) (cons (cons nx ny) st))
                     st)))
             (loop newstack)))
         (+ count 1)]
        [else count])))
  (if (not (= (count-islands) 1))
      0
      (let/ec return
        (for* ([i (in-range rows)] [j (in-range cols)])
          (when (= (gref i j) 1)
            (gset! i j 0)
            (cond
              [(not (= (count-islands) 1))
               (gset! i j 1)
               (return 1)]
              [else (gset! i j 1)])))
        2)))

(provide (all-defined-out))
