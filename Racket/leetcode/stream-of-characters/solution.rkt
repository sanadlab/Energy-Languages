#lang racket
(require "../../../selection/nodes.rkt")

(define stream-checker%
  (class object%
    (super-new)

    ; words : (listof string?)
    (init-field
      words)

    (define trie (make-hash))
    (define stream '())   ; newest char first
    (define cnt 0)
    (define max-len 0)

    (for ([w (in-list words)])
      (let loop ([node trie] [chars (reverse (string->list w))])
        (if (null? chars)
            (hash-set! node 'end #t)
            (let* ([ch (car chars)]
                   [child (hash-ref node ch #f)]
                   [nxt (or child (let ([h (make-hash)]) (hash-set! node ch h) h))])
              (loop nxt (cdr chars)))))
      (when (> (string-length w) max-len) (set! max-len (string-length w))))

    ; query : char? -> boolean?
    (define/public (query letter)
      (define ch (if (char? letter) letter (string-ref letter 0)))
      (set! stream (cons ch stream))
      (set! cnt (add1 cnt))
      (define nmax (min max-len cnt))
      (let loop ([node trie] [step 0] [lst stream])
        (cond
          [(>= step nmax) #f]
          [else
           (define c (car lst))
           (define child (hash-ref node c #f))
           (cond
             [(not child) #f]
             [(hash-ref child 'end #f) #t]
             [else (loop child (add1 step) (cdr lst))])])))))

;; Your stream-checker% object will be instantiated and called as such:
;; (define obj (new stream-checker% [words words]))
;; (define param_1 (send obj query letter))

(provide (all-defined-out))
