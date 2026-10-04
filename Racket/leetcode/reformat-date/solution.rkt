#lang racket
(require "../../../selection/nodes.rkt")

(define/contract (reformat-date date)
  (-> string? string?)
  (define months (hash "Jan" "01" "Feb" "02" "Mar" "03" "Apr" "04"
                       "May" "05" "Jun" "06" "Jul" "07" "Aug" "08"
                       "Sep" "09" "Oct" "10" "Nov" "11" "Dec" "12"))
  (define parts (string-split date))
  (cond
    [(< (length parts) 3) ""]
    [else
     (define p0 (list-ref parts 0))
     (define day0 (if (>= (string-length p0) 2)
                      (substring p0 0 (- (string-length p0) 2))
                      p0))
     (define day (if (= (string-length day0) 1) (string-append "0" day0) day0))
     (define month (hash-ref months (list-ref parts 1) "01"))
     (string-append (list-ref parts 2) "-" month "-" day)]))

(provide (all-defined-out))
