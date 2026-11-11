#lang racket
;; Full-suite correctness validator (Racket). Runs solution.rkt against EVERY
;; reference case and compares each result to the expected output. Run FROM the
;; cell dir:  racket ../../../selection/validate_suite.rkt
;; Reuses rkt_hns.rkt so correctness judges the exact same shared inputs the
;; measurement harness does. Prints one VALIDATE line to stderr. Exit:
;;   0 Accepted, 1 Wrong Answer, 3 Runtime Error, 2 the solution cannot be
;;   compiled (read error, syntax error, unbound identifier, no entry point)
;;   or setup error.
(require "nodes.rkt" "rkt_hns.rkt" racket/class)

(define UNORDERED
  '("uncommon-words-from-two-sentences" "remove-invalid-parentheses" "restore-the-array-from-adjacent-pairs" "ambiguous-coordinates"))

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
  (define snippet (cell-snippet))
  ;; Compile the solution once, before any case, without running it (visit
  ;; only): an error here is a Compile Error, not a Runtime Error of case 1.
  (define (load-fail msg) (err-exit 2 (format "VALIDATE slug=~a ERROR load: ~a" slug msg)))
  (with-handlers ([(lambda (_) #t) (lambda (e) (load-fail (if (exn? e) (exn-message e) e)))])
    (dynamic-require solpath (void)))
  (define entry
    (let ([inp (obj-ref (car expected) "input")])
      (if (design? inp)
          (string->symbol (string-append (kebab (car (obj-ref inp "ops"))) "%"))
          (string->symbol (kebab camel)))))
  (define-values (vars stxs) (module->exports solpath))
  (unless (for/or ([l (list vars stxs)])
            (assq entry (cond [(assv 0 l) => cdr] [else '()])))
    (load-fail (format "solution.rkt does not provide `~a`" entry)))
  (for ([c (in-list expected)] [i (in-naturals)])
    (define name (obj-ref c "name"))
    (define inp (obj-ref c "input"))
    (define exp (obj-ref c "output"))
    (define is-design (design? inp))
    (define actual
      (with-handlers ([(lambda (_) #t)
                       (lambda (e) (err-exit 3 (format "VALIDATE slug=~a RE case=~a passed=~a ncases=~a ~a"
                                                       slug name i total (if (exn? e) (exn-message e) e))))])
        (run-case solpath inp camel randomized snippet)))
    (define ok
      (cond [is-design (seq-ok actual exp)]
            [(member slug UNORDERED) (unordered-eq actual exp)]
            [else (same? actual exp)]))
    (unless ok
      (err-exit 1 (format "VALIDATE slug=~a FAIL case=~a passed=~a ncases=~a expected=~a actual=~a"
                          slug name i total (trunc (canon exp)) (trunc (canon actual))))))
  (eprintf "VALIDATE slug=~a PASS ncases=~a passed=~a\n" slug total total)
  (exit 0))

(define (trunc s) (if (> (string-length s) 120) (substring s 0 120) s))

(define (run-case solpath inp camel randomized snippet)
  (cond
    [(design? inp)
     (define ops (obj-ref inp "ops"))
     (define args (obj-ref inp "args"))
     (define cls-name (string->symbol (string-append (kebab (car ops)) "%")))
     (define cls (dynamic-require solpath cls-name))
     (define nums (and randomized (car (car args))))
     (define obj (apply (design-ctor snippet cls-name) cls
                        (apply-convs (ctor-convs snippet cls-name) (car args))))
     (cons 'null
           (for/list ([op (in-list (cdr ops))] [a (in-list (cdr args))])
             (define m (string->symbol (kebab op)))
             (define r (apply dynamic-send obj m (apply-convs (arg-convs snippet m) a)))
             (if (and randomized (string=? op "pick") (exact-integer? r)) (list-ref nums r) r)))]
    [else
     (define name (string->symbol (kebab camel)))
     (define f (dynamic-require solpath name))
     (apply f (build-args inp (arg-convs snippet name)))]))

(define (seq-ok actual expected)
  (and (list? actual) (list? expected) (= (length actual) (length expected))
       (for/and ([a (in-list actual)] [e (in-list expected)])
         (or (eq? e 'null) (same? a e)))))

;; Do two results match? Equal canon forms match. Otherwise numbers match when
;; one of them is a non-integer float and they differ by at most 1e-5 (LeetCode
;; accepts answers within 1e-5 on its float problems); lists match element by
;; element; everything else must be equal.
(define (same? a e)
  (define ca (canon a)) (define ce (canon e))
  (or (string=? ca ce)
      (with-handlers ([exn:fail? (lambda (_) #f)])
        (close? (parse-ordered ca) (parse-ordered ce)))))

(define (close? a e)
  (cond [(and (real? a) (real? e))
         (or (= a e) (and (or (inexact? a) (inexact? e)) (<= (abs (- a e)) 1e-5)))]
        [(and (list? a) (list? e)) (and (= (length a) (length e)) (andmap close? a e))]
        [else (equal? a e)]))

(define (unordered-eq a e)
  (if (and (list? a) (list? e))
      (equal? (sort (map canon a) string<?) (sort (map canon e) string<?))
      (string=? (canon a) (canon e))))

(main)
