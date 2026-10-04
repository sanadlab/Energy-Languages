#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (is-solvable words result)
  (-> (listof string?) string? boolean?)
  (define max-len (string-length result))
  (cond
    [(for/or ([w (in-list words)]) (> (string-length w) max-len)) #f]
    [else
     (define wv (list->vector words))
     (define nwords (vector-length wv))
     (define assigned (make-hash))   ; char -> digit
     (define used (make-vector 10 #f))
     (define leading (make-hash))    ; char -> #t
     (for ([w (in-list words)])
       (when (> (string-length w) 1) (hash-set! leading (string-ref w 0) #t)))
     (when (> (string-length result) 1) (hash-set! leading (string-ref result 0) #t))
     (define (char-at s col) (string-ref s (- (string-length s) 1 col)))
     (define (solve col row carry)
       (cond
         [(= col max-len) (= carry 0)]
         [(< row nwords)
          (define w (vector-ref wv row))
          (cond
            [(>= col (string-length w)) (solve col (add1 row) carry)]
            [else
             (define ch (char-at w col))
             (cond
               [(hash-has-key? assigned ch) (solve col (add1 row) carry)]
               [else
                (let loop ([d 0])
                  (cond
                    [(>= d 10) #f]
                    [(and (not (vector-ref used d))
                          (not (and (= d 0) (hash-has-key? leading ch))))
                     (vector-set! used d #t)
                     (hash-set! assigned ch d)
                     (cond
                       [(solve col (add1 row) carry) #t]
                       [else
                        (vector-set! used d #f)
                        (hash-remove! assigned ch)
                        (loop (add1 d))])]
                    [else (loop (add1 d))]))])])]
         [else
          (define s
            (for/fold ([s carry]) ([w (in-list words)])
              (if (< col (string-length w))
                  (+ s (hash-ref assigned (char-at w col)))
                  s)))
          (define digit (modulo s 10))
          (define new-carry (quotient s 10))
          (define rch (char-at result col))
          (cond
            [(hash-has-key? assigned rch)
             (if (= (hash-ref assigned rch) digit)
                 (solve (add1 col) 0 new-carry)
                 #f)]
            [(vector-ref used digit) #f]
            [(and (= digit 0) (hash-has-key? leading rch)) #f]
            [else
             (vector-set! used digit #t)
             (hash-set! assigned rch digit)
             (cond
               [(solve (add1 col) 0 new-carry) #t]
               [else
                (vector-set! used digit #f)
                (hash-remove! assigned rch)
                #f])])]))
     (solve 0 0 0)]))

(provide (all-defined-out))
