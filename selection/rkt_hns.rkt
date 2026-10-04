#lang racket
;; Shared helpers for the Racket loop-harness (harness.rkt) and the full-suite
;; validator (validate_suite.rkt). Mirrors selection/harness.rb semantics so
;; Racket cells are measured + judged on the SAME shared JSON inputs as every
;; other language. The canon/fold form only needs to be INTERNALLY consistent.
;;
;; JSON is parsed with a hand-rolled ORDERED parser so the generic single-method
;; path can recover parameter order; objects become (jobj (list (cons key val)…))
;; in source order, arrays become lists, null becomes 'null.
(require "nodes.rkt")
(provide (all-defined-out))

(struct jobj (pairs) #:transparent)

(define (obj-ref o key [default #f])
  (cond [(assoc key (jobj-pairs o)) => cdr] [else default]))

;; ---- ordered JSON parser ----------------------------------------------------
(define (parse-ordered s)
  (define in (open-input-string s))
  (skip-ws in)
  (parse-val in))

(define (skip-ws in)
  (let loop ()
    (define c (peek-char in))
    (when (and (char? c) (char-whitespace? c)) (read-char in) (loop))))

(define (parse-val in)
  (skip-ws in)
  (define c (peek-char in))
  (cond
    [(char=? c #\{) (parse-obj in)]
    [(char=? c #\[) (parse-arr in)]
    [(char=? c #\") (parse-str in)]
    [(char=? c #\t) (read-string 4 in) #t]
    [(char=? c #\f) (read-string 5 in) #f]
    [(char=? c #\n) (read-string 4 in) 'null]
    [else (parse-num in)]))

(define (parse-obj in)
  (read-char in) ; {
  (let loop ([acc '()])
    (skip-ws in)
    (define c (peek-char in))
    (cond
      [(char=? c #\}) (read-char in) (jobj (reverse acc))]
      [else
       (define k (parse-str in))
       (skip-ws in) (read-char in) ; :
       (define v (parse-val in))
       (skip-ws in)
       (define d (read-char in)) ; , or }
       (if (char=? d #\})
           (jobj (reverse (cons (cons k v) acc)))
           (loop (cons (cons k v) acc)))])))

(define (parse-arr in)
  (read-char in) ; [
  (skip-ws in)
  (cond
    [(char=? (peek-char in) #\]) (read-char in) '()]
    [else
     (let loop ([acc '()])
       (define v (parse-val in))
       (skip-ws in)
       (define d (read-char in)) ; , or ]
       (if (char=? d #\])
           (reverse (cons v acc))
           (begin (skip-ws in) (loop (cons v acc)))))]))

(define (parse-str in)
  (read-char in) ; opening "
  (define out (open-output-string))
  (let loop ()
    (define c (read-char in))
    (cond
      [(char=? c #\") (get-output-string out)]
      [(char=? c #\\)
       (define e (read-char in))
       (cond
         [(char=? e #\u)
          (define hex (read-string 4 in))
          (write-char (integer->char (string->number hex 16)) out)]
         [else (write-char (unescape e) out)])
       (loop)]
      [else (write-char c out) (loop)])))

(define (unescape e)
  (case e [(#\n) #\newline] [(#\t) #\tab] [(#\r) #\return]
          [(#\b) #\backspace] [(#\f) #\page] [else e]))

(define (parse-num in)
  (define out (open-output-string))
  (let loop ()
    (define c (peek-char in))
    (when (and (char? c) (or (char-numeric? c) (memv c '(#\- #\+ #\. #\e #\E))))
      (write-char (read-char in) out) (loop)))
  (string->number (get-output-string out)))

;; ---- camelCase -> kebab-case ------------------------------------------------
(define (kebab s)
  (let* ([s (if (symbol? s) (symbol->string s) s)]
         [s (regexp-replace* #rx"([A-Z]+)([A-Z][a-z])" s "\\1-\\2")]
         [s (regexp-replace* #rx"([a-z0-9])([A-Z])" s "\\1-\\2")])
    (string-downcase s)))

;; ---- node construction (compact LeetCode level-order) -----------------------
(define (build-tree a)
  (cond
    [(or (eq? a 'null) (null? a) (eq? (car a) 'null)) #f]
    [else
     (define root (make-tree-node (car a)))
     (let loop ([q (list root)] [rest (cdr a)])
       (cond
         [(or (null? q) (null? rest)) root]
         [else
          (define node (car q))
          (define-values (lchild rest1) (take-child rest))
          (define-values (rchild rest2) (take-child rest1))
          (when lchild (set-tree-node-left! node lchild))
          (when rchild (set-tree-node-right! node rchild))
          (loop (append (cdr q) (filter values (list lchild rchild))) rest2)]))]))

(define (take-child rest)
  (cond
    [(null? rest) (values #f '())]
    [(eq? (car rest) 'null) (values #f (cdr rest))]
    [else (values (make-tree-node (car rest)) (cdr rest))]))

(define (build-list a)
  (cond
    [(or (eq? a 'null) (null? a)) #f]
    [else (let loop ([vs (reverse a)] [acc #f])
            (if (null? vs) acc (loop (cdr vs) (list-node (car vs) acc))))]))

(define (tree->list root)
  (if (not root) '()
      (let loop ([q (list root)] [acc '()])
        (cond
          [(null? q) (trim-trailing (reverse acc))]
          [(not (car q)) (loop (cdr q) (cons 'null acc))]
          [else (define n (car q))
                (loop (append (cdr q) (list (tree-node-left n) (tree-node-right n)))
                      (cons (tree-node-val n) acc))]))))

(define (trim-trailing lst)
  (reverse (dropf (reverse lst) (lambda (x) (eq? x 'null)))))

(define (lnode->list h)
  (let loop ([h h] [acc '()])
    (if (not h) (reverse acc) (loop (list-node-next h) (cons (list-node-val h) acc)))))

;; ---- canonical form ---------------------------------------------------------
(define (canon v)
  (cond
    [(eq? v 'null) "null"]
    [(eq? v #t) "true"]
    [(eq? v #f) "false"]
    [(tree-node? v) (canon (tree->list v))]
    [(list-node? v) (canon (lnode->list v))]
    [(and (number? v) (exact-integer? v)) (number->string v)]
    [(and (number? v) (real? v)) (fmt-real v)]
    [(string? v) (json-string v)]
    [(symbol? v) (json-string (symbol->string v))]
    [(jobj? v) (canon-obj (jobj-pairs v))]
    [(hash? v) (canon-obj (hash->list v))]
    [(list? v) (string-append "[" (string-join (map canon v) ",") "]")]
    [else (json-string (format "~a" v))]))

(define (fmt-real v)
  (if (integer? v) (number->string (inexact->exact (round v))) (number->string v)))

(define (canon-obj pairs)
  (define sorted (sort pairs string<? #:key (lambda (p) (format "~a" (car p)))))
  (string-append "{"
    (string-join (map (lambda (p) (string-append (json-string (format "~a" (car p))) ":" (canon (cdr p)))) sorted) ",")
    "}"))

(define (json-string s)
  (define e (regexp-replace* #rx"\n" (regexp-replace* #rx"\t" (regexp-replace* #rx"\"" (regexp-replace* #rx"\\\\" s "\\\\\\\\") "\\\\\"") "\\\\t") "\\\\n"))
  (string-append "\"" e "\""))

;; ---- checksum fold ----------------------------------------------------------
(define MASK64 (sub1 (expt 2 64)))
(define (strhash s)
  (for/fold ([h 0]) ([b (in-bytes (string->bytes/utf-8 s))])
    (bitwise-and (+ (* h 31) b) #xFFFFFFFF)))
(define (fold acc r) (bitwise-and (+ (* acc 1000003) (strhash (canon r))) MASK64))

;; ---- build positional args from an ordered input object --------------------
(define (build-args o)
  (for/list ([p (in-list (jobj-pairs o))])
    (define k (car p)) (define v (cdr p))
    (cond [(string=? k "root") (build-tree v)]
          [(string=? k "head") (build-list v)]
          [else v])))

(define (design? o)
  (and (jobj? o) (assoc "ops" (jobj-pairs o)) (assoc "args" (jobj-pairs o)) #t))
