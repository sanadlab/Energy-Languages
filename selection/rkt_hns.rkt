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
;; The BFS queues are two lists (front, and back in reverse), so building and
;; walking a tree takes linear time.
(define (build-tree a)
  (cond
    [(or (eq? a 'null) (null? a) (eq? (car a) 'null)) #f]
    [else
     (define root (make-tree-node (car a)))
     (let loop ([front (list root)] [back '()] [rest (cdr a)])
       (cond
         [(null? rest) root]
         [(null? front) (if (null? back) root (loop (reverse back) '() rest))]
         [else
          (define node (car front))
          (define-values (lchild rest1) (take-child rest))
          (define-values (rchild rest2) (take-child rest1))
          (when lchild (set-tree-node-left! node lchild))
          (when rchild (set-tree-node-right! node rchild))
          (define back1 (if lchild (cons lchild back) back))
          (loop (cdr front) (if rchild (cons rchild back1) back1) rest2)]))]))

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
      (let loop ([front (list root)] [back '()] [acc '()])
        (cond
          [(null? front)
           (if (null? back) (trim-trailing (reverse acc)) (loop (reverse back) '() acc))]
          [(not (car front)) (loop (cdr front) back (cons 'null acc))]
          [else (define n (car front))
                (loop (cdr front) (list* (tree-node-right n) (tree-node-left n) back)
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
;; Every call builds fresh values (strings are mutable in Racket); `convs` are
;; the per-argument converters from the snippet's contract (see arg-convs).
(define (build-args o [convs '()])
  (apply-convs convs
    (for/list ([p (in-list (jobj-pairs o))])
      (define k (car p)) (define v (cdr p))
      (cond [(string=? k "root") (build-tree v)]
            [(string=? k "head") (build-list v)]
            [else (fresh v)]))))

(define (fresh v)
  (cond [(string? v) (string-copy v)]
        [(pair? v) (map fresh v)]
        [else v]))

(define (apply-convs convs vals)
  (cond [(or (null? convs) (null? vals)) vals]
        [else (cons (if (car convs) ((car convs) (car vals)) (car vals))
                    (apply-convs (cdr convs) (cdr vals)))]))

;; ---- LeetCode's Racket snippet (code_snippets.racket in the cell's problem.json)
;; LeetCode passes a char where the snippet's contract says char? (the shared
;; JSON holds a 1-char string), and builds a design object with named init
;; arguments, (new custom-stack% [max-size 3]), not by position.
(define (cell-snippet)
  (with-handlers ([exn:fail? (lambda (_) #f)])
    (define s (obj-ref (obj-ref (parse-ordered (file->string "problem.json")) "code_snippets") "racket"))
    (and (string? s) s)))

(define (snippet-forms s)
  (with-handlers ([exn:fail? (lambda (_) '())])
    (parameterize ([read-accept-reader #f] [read-accept-lang #f])
      (define in (open-input-string s))
      (let loop ([acc '()])
        (define f (read in))
        (if (eof-object? f) (reverse acc) (loop (cons f acc)))))))

;; contract -> converter of one argument, or #f when the value passes unchanged
(define (contract-conv c)
  (cond [(eq? c 'char?)
         (lambda (v) (if (and (string? v) (= (string-length v) 1)) (string-ref v 0) v))]
        [(and (pair? c) (memq (car c) '(listof non-empty-listof)) (pair? (cdr c))
              (contract-conv (cadr c)))
         => (lambda (f) (lambda (v) (if (list? v) (map f v) v)))]
        [else #f]))

(define (convs-of ctcs) (let ([cs (map contract-conv ctcs)]) (if (ormap values cs) cs '())))

;; Converters of the arguments of `name` (a symbol): the domain of its
;; define/contract, or of a `; name : dom ... -> rng` comment (a design
;; method), or the `; name : ctc` comment of an init field. '() = none.
;; Cached: the validator asks once per design operation.
(define convs-cache (make-hash))
(define (arg-convs snippet name)
  (hash-ref! convs-cache (cons snippet name) (lambda () (arg-convs* snippet name))))
(define (arg-convs* snippet name)
  (cond
    [(not (and snippet (regexp-match? #rx"char[?]" snippet))) '()]
    [(for/first ([f (in-list (snippet-forms snippet))]
                 #:when (and (pair? f) (eq? (car f) 'define/contract) (pair? (cdr f))
                             (pair? (cadr f)) (eq? (car (cadr f)) name) (pair? (cddr f))))
       (caddr f))
     => (lambda (ctc) (if (and (pair? ctc) (eq? (car ctc) '->) (pair? (cdr ctc)))
                          (convs-of (drop-right (cdr ctc) 1)) '()))]
    [(for/first ([line (in-list (string-split snippet "\n"))]
                 #:when (regexp-match? (pregexp (string-append "^\\s*;+\\s*" (regexp-quote (symbol->string name)) "\\s*:")) line))
       (cadr (regexp-match #px":(.*)$" line)))
     => (lambda (sig)
          (define dom (car (string-split (string-append sig " ") "->" #:trim? #f)))
          (with-handlers ([exn:fail? (lambda (_) '())])
            (convs-of (read (open-input-string (string-append "(" dom ")"))))))]
    [else '()]))

;; Init-field names of the snippet's class `cls` (a symbol such as
;; custom-stack%), in order, or #f when the snippet does not define it.
(define (init-names snippet cls)
  (and snippet
       (for/first ([f (in-list (snippet-forms snippet))]
                   #:when (and (pair? f) (eq? (car f) 'define) (pair? (cdr f)) (eq? (cadr f) cls)
                               (pair? (cddr f)) (pair? (caddr f))))
         (append*
          (for/list ([g (in-list (caddr f))]
                     #:when (and (pair? g) (memq (car g) '(init-field init))))
            (for/list ([x (in-list (cdr g))])
              (cond [(not (pair? x)) x] [(pair? (car x)) (cadr (car x))] [else (car x)])))))))

(define-namespace-anchor hns-anchor)
;; (ctor cls arg ...) -> a new object: (new cls [init-name arg] ...) with the
;; snippet's init-field names, by position when the names are unknown.
(define (design-ctor snippet cls)
  (define names (init-names snippet cls))
  (if (not names)
      (lambda (c . args) (apply make-object c args))
      (let ([ids (for/list ([i (in-range (length names))]) (string->symbol (format "a~a" i)))])
        (eval `(lambda (c ,@ids) (new c ,@(map list names ids)))
              (namespace-anchor->namespace hns-anchor)))))

;; Converters of the init arguments of `cls`, from the init fields' comments.
(define (ctor-convs snippet cls)
  (define names (or (init-names snippet cls) '()))
  (define cs (for/list ([n (in-list names)])
               (let ([c (arg-convs snippet n)]) (and (pair? c) (car c)))))
  (if (ormap values cs) cs '()))

(define (design? o)
  (and (jobj? o) (assoc "ops" (jobj-pairs o)) (assoc "args" (jobj-pairs o)) #t))
