#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (ladder-length beginWord endWord wordList)
  (-> string? string? (listof string?) exact-integer?)
  (define word-set (list->set wordList))
  (cond
    [(not (set-member? word-set endWord)) 0]
    [else
     (define alphabet (string->list "abcdefghijklmnopqrstuvwxyz"))
     (define (neighbors-of w)
       (for*/list ([i (in-range (string-length w))]
                   [c (in-list alphabet)])
         (string-append (substring w 0 i) (string c) (substring w (add1 i)))))
     (let bfs ([frontier (list beginWord)] [visited (set beginWord)] [level 1])
       (if (null? frontier)
           0
           (let process ([words frontier] [next '()] [vis visited])
             (if (null? words)
                 (bfs next vis (add1 level))
                 (let scan ([neighbors (neighbors-of (car words))] [next next] [vis vis])
                   (cond
                     [(null? neighbors) (process (cdr words) next vis)]
                     [else
                      (define nw (car neighbors))
                      (cond
                        [(string=? nw endWord) (add1 level)]
                        [(and (set-member? word-set nw) (not (set-member? vis nw)))
                         (scan (cdr neighbors) (cons nw next) (set-add vis nw))]
                        [else (scan (cdr neighbors) next vis)])]))))))]))

(provide (all-defined-out))
