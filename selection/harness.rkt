#lang racket
;; Generic Racket loop-harness for the per-op cross-language measurement.
;; Reads the SAME shared JSON inputs as the other languages, dynamic-requires the
;; cell's solution.rkt, and loops the call to a wall-time budget (checksum-folded,
;; iteration-counted).
;;
;;   racket ../../../selection/harness.rkt <budget_seconds> <case_index>
;;   (run FROM the cell dir; prints CASE/ITERS/ACC/MEAS_S/BEACON to stderr).
;;
;; Racket structs are mutable, so (like the Ruby harness) a solution that mutates
;; its input is detected once and its args are rebuilt each iteration; otherwise
;; the built args are reused. Design problems use the Racket class system: a fresh
;; object is created each replay (clean state), methods called via dynamic-send.
(require "nodes.rkt" "rkt_hns.rkt" racket/class)

(define (now) (current-inexact-monotonic-milliseconds))

(define (main)
  (define argv (current-command-line-arguments))
  (define budget (string->number (vector-ref argv 0)))
  (define idx (string->number (vector-ref argv 1)))
  (define slug (path->string (last (explode-path (current-directory)))))
  (define ref (build-path (current-directory) 'up 'up 'up "reference" "leetcode"))
  (define solpath (path->complete-path "solution.rkt"))
  (define out (parse-ordered (file->string (build-path ref "outputs" (string-append slug ".json")))))
  (define kase (list-ref (obj-ref out "expected") idx))
  (define name (obj-ref kase "name"))
  (define input (obj-ref kase "input"))
  (define warm (* budget 0.3))
  (define-values (one beacon)
    (if (design? input)
        (values (make-design-closure solpath input) "design")
        (make-generic solpath ref slug input)))
  ;; estimate per-iter cost during warmup, then batch the wall-clock read
  (define t0 (now))
  (define wi (let loop ([n 0]) (if (>= (now) (+ t0 (* warm 1000.0))) n (begin (one) (loop (add1 n))))))
  (define per-ms (if (> wi 0) (/ (- (now) t0) wi) warm))
  (define batch (if (> per-ms 0) (max 1 (min 4096 (inexact->exact (floor (/ 2.0 per-ms))))) 4096))
  (define tm (now))
  (define deadline (+ tm (* (- budget warm) 1000.0)))
  (define-values (acc iters)
    (let loop ([acc 0] [iters 0])
      (if (>= (now) deadline) (values acc iters)
          (loop (do-batch one acc batch) (+ iters batch)))))
  (define meas (/ (- (now) tm) 1000.0))
  (eprintf "CASE=~a ITERS=~a ACC=~a MEAS_S=~a BEACON=~a\n"
           name iters acc (real->decimal-string meas 6) beacon))

(define (do-batch one acc k) (if (= k 0) acc (do-batch one (fold acc (one)) (sub1 k))))

(define (make-generic solpath ref slug input)
  (define wl (parse-ordered (file->string (build-path ref "workloads" (string-append slug ".json")))))
  (define camel (last (string-split (format "~a" (obj-ref wl "entry_point")) ".")))
  (define f (dynamic-require solpath (string->symbol (kebab camel))))
  (define (mk-args) (build-args input))
  (define beacon-val (apply f (mk-args)))
  (define snap (map canon (mk-args)))
  (define probe (mk-args))
  (apply f probe)
  (define mutated (not (equal? (map canon probe) snap)))
  (define thunk
    (if mutated
        (lambda () (apply f (mk-args)))
        (let ([a (mk-args)]) (lambda () (apply f a)))))
  (values thunk (let ([c (canon beacon-val)]) (if (> (string-length c) 80) (substring c 0 80) c))))

(define (make-design-closure solpath input)
  (define ops (obj-ref input "ops"))
  (define args (obj-ref input "args"))
  (define cls (dynamic-require solpath (string->symbol (string-append (kebab (car ops)) "%"))))
  (define ctor-args (car args))
  (define rest-ops (cdr ops))
  (define rest-args (cdr args))
  (lambda ()
    (define obj (apply make-object cls ctor-args))
    (for/fold ([acc 0]) ([op (in-list rest-ops)] [a (in-list rest-args)])
      (fold acc (apply dynamic-send obj (string->symbol (kebab op)) a)))))

(main)
