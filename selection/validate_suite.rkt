#lang racket
;; Full-suite correctness validator (Racket). Runs solution.rkt against EVERY
;; reference case and compares each result to the expected output. Run FROM the
;; cell dir:  racket ../../../selection/validate_suite.rkt
;; Reuses rkt_hns.rkt so correctness judges the exact same shared inputs the
;; measurement harness does. Prints one VALIDATE line to stderr. Exit:
;;   0 Accepted, 1 Wrong Answer, 3 Runtime Error, 2 setup error.
(require "nodes.rkt" "rkt_hns.rkt" racket/class)

(define UNORDERED
  '("uncommon-words-from-two-sentences" "remove-invalid-parentheses" "restore-the-array-from-adjacent-pairs"))

(define (err-exit code msg) (eprintf "~a\n" msg) (exit code))

(define (main)
  (define slug (path->string (last (explode-path (current-directory)))))
  (define ref (build-path (current-directory) 'up 'up 'up "reference" "leetcode"))
  (define solpath (path->complete-path "solution.rkt"))
  (define out #f) (define camel #f)
  (with-handlers ([exn:fail? (lambda (e) (err-exit 2 (format "VALIDATE slug=~a ERROR load: ~a" slug (exn-message e))))])
    (set! out (parse-ordered (file->string (build-path ref "outputs" (string-append slug ".json")))))
    (define wl (parse-ordered (file->string (build-path ref "workloads" (string-append slug ".json")))))
    (set! camel (last (string-split (format "~a" (obj-ref wl "entry_point")) "."))))
  (define randomized (string=? slug "random-pick-index"))
  (define expected (obj-ref out "expected"))
  (define total (length expected))
  (for ([c (in-list expected)] [i (in-naturals)])
    (define name (obj-ref c "name"))
    (define inp (obj-ref c "input"))
    (define exp (obj-ref c "output"))
    (define is-design (design? inp))
    (define actual
      (with-handlers ([(lambda (_) #t)
                       (lambda (e) (err-exit 3 (format "VALIDATE slug=~a RE case=~a passed=~a ncases=~a ~a"
                                                       slug name i total (if (exn? e) (exn-message e) e))))])
        (run-case solpath inp camel randomized)))
    (define ok
      (cond [is-design (seq-ok actual exp)]
            [(member slug UNORDERED) (unordered-eq actual exp)]
            [else (string=? (canon actual) (canon exp))]))
    (unless ok
      (err-exit 1 (format "VALIDATE slug=~a FAIL case=~a passed=~a ncases=~a expected=~a actual=~a"
                          slug name i total (trunc (canon exp)) (trunc (canon actual))))))
  (eprintf "VALIDATE slug=~a PASS ncases=~a passed=~a\n" slug total total)
  (exit 0))

(define (trunc s) (if (> (string-length s) 120) (substring s 0 120) s))

(define (run-case solpath inp camel randomized)
  (cond
    [(design? inp)
     (define ops (obj-ref inp "ops"))
     (define args (obj-ref inp "args"))
     (define cls (dynamic-require solpath (string->symbol (string-append (kebab (car ops)) "%"))))
     (define nums (and randomized (car (car args))))
     (define obj (apply make-object cls (car args)))
     (cons 'null
           (for/list ([op (in-list (cdr ops))] [a (in-list (cdr args))])
             (define r (apply dynamic-send obj (string->symbol (kebab op)) a))
             (if (and randomized (string=? op "pick") (exact-integer? r)) (list-ref nums r) r)))]
    [else
     (define f (dynamic-require solpath (string->symbol (kebab camel))))
     (apply f (build-args inp))]))

(define (seq-ok actual expected)
  (and (list? actual) (list? expected) (= (length actual) (length expected))
       (for/and ([a (in-list actual)] [e (in-list expected)])
         (or (eq? e 'null) (string=? (canon a) (canon e))))))

(define (unordered-eq a e)
  (if (and (list? a) (list? e))
      (equal? (sort (map canon a) string<?) (sort (map canon e) string<?))
      (string=? (canon a) (canon e))))

(main)
