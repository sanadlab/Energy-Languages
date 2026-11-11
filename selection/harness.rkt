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
;; its input is detected once; it then gets a fresh copy of its args per call,
;; made outside the timed region. Otherwise the built args are reused. Design
;; problems use the Racket class system: a fresh object is created each replay
;; (clean state, named init arguments as on LeetCode), methods called via
;; dynamic-send. Arguments whose snippet contract is char? are passed as chars.
;; Measurement runs start this file compiled (run_harness.sh build/run mode).
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
  (define snippet (cell-snippet))
  ;; one: a call (design: a replay) on the shared input; mk: a fresh copy of the
  ;; input (copy mode only, else #f); call: a call on such a copy
  (define-values (one mk call beacon)
    (if (design? input)
        (values (make-design-closure solpath input snippet) #f #f "design")
        (make-generic solpath ref slug input snippet)))
  ;; estimate per-iter cost during warmup, then batch the wall-clock read
  (define t0 (now))
  (define wi (let loop ([n 0]) (if (>= (now) (+ t0 (* warm 1000.0))) n
                                   (begin (if mk (call (mk)) (one)) (loop (add1 n))))))
  (define per-ms (if (> wi 0) (/ (- (now) t0) wi) warm))
  (define batch0 (if (> per-ms 0) (max 1 (min 4096 (inexact->exact (floor (/ 2.0 per-ms))))) 4096))
  ;; memory pass: one copy at a time
  (define batch (if (and mk (non-empty-string? (or (getenv "PERFARENA_MEM_PASS") ""))) 1 batch0))
  (define target (* (- budget warm) 1000.0))
  (define tm (now))
  (define-values (acc iters meas-ms)
    (let loop ([acc 0] [iters 0] [meas 0.0])
      (if (or (>= meas target) (>= (- (now) tm) (* 4 target))) (values acc iters meas)
          (let* ([pool (and mk (for/list ([_ (in-range batch)]) (mk)))]   ; untimed
                 [t (now)]
                 [acc2 (if pool
                           (for/fold ([a acc]) ([c (in-list pool)]) (fold a (call c)))
                           (do-batch one acc batch))]
                 [dt (- (now) t)])
            (loop acc2 (+ iters batch) (+ meas dt))))))
  (define meas (/ meas-ms 1000.0))
  (eprintf "CASE=~a ITERS=~a ACC=~a MEAS_S=~a BEACON=~a\n"
           name iters acc (real->decimal-string meas 6) beacon))

(define (do-batch one acc k) (if (= k 0) acc (do-batch one (fold acc (one)) (sub1 k))))

(define (make-generic solpath ref slug input snippet)
  (define wl (parse-ordered (file->string (build-path ref "workloads" (string-append slug ".json")))))
  (define camel (last (string-split (format "~a" (obj-ref wl "entry_point")) ".")))
  (define name (string->symbol (kebab camel)))
  (define f (dynamic-require solpath name))
  (define convs (arg-convs snippet name))
  (define (mk-args) (build-args input convs))
  (define beacon-val (apply f (mk-args)))
  (define snap (map canon (mk-args)))
  (define probe (mk-args))
  (apply f probe)
  (define mutated (not (equal? (map canon probe) snap)))
  (define base (mk-args))
  (values (lambda () (apply f base))
          (and mutated mk-args)
          (lambda (a) (apply f a))
          (let ([c (canon beacon-val)]) (if (> (string-length c) 80) (substring c 0 80) c))))

(define (make-design-closure solpath input snippet)
  (define ops (obj-ref input "ops"))
  (define args (obj-ref input "args"))
  (define cls-name (string->symbol (string-append (kebab (car ops)) "%")))
  (define cls (dynamic-require solpath cls-name))
  (define ctor (design-ctor snippet cls-name))
  (define ctor-args (apply-convs (ctor-convs snippet cls-name) (car args)))
  (define rest-ops (for/list ([op (in-list (cdr ops))]) (string->symbol (kebab op))))
  (define rest-args (for/list ([m (in-list rest-ops)] [a (in-list (cdr args))])
                      (apply-convs (arg-convs snippet m) a)))
  (lambda ()
    (define obj (apply ctor cls ctor-args))
    (for/fold ([acc 0]) ([m (in-list rest-ops)] [a (in-list rest-args)])
      (fold acc (apply dynamic-send obj m a)))))

(main)
