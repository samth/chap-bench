#lang racket

(define-syntax-rule (check e) e)
#;
(define-syntax-rule (check e)
  (let ([v e])
    (unless (integer? v) (error "bad"))
    v))

(define e (lambda (x) x))
#;
(define e (lambda (x) (string->number (number->string x))))

(define f #f)
(set! f e)

(define g #f)
(set! g (lambda (x) (check (f (check x)))))

(define g2 #f)
(set! g2 (lambda (x) (values (f (check x)) (lambda (y) (check y)))))

(define h0 (impersonate-procedure f (lambda (x) (check x))))

(define h (impersonate-procedure f
                                 (lambda (x)
                                   (values (lambda (y) (check y)) (check x)))))

(define j (chaperone-procedure f
                               (lambda (x)
                                 (values (lambda (y) (check y)) (check x)))))

(define k (chaperone-procedure f
                               (lambda (x)
                                 (values (lambda (y) (check y)) (check x)))
                               impersonator-prop:application-mark
                               '(1 . 2)))

(define N 10000000)

'inlined
(time
 (for ([i (in-range N)])
   (e i)))

'plain
(time
 (for ([i (in-range N)])
   (f i)))

'wrapped
(time
 (for ([i (in-range N)])
   (g i)))

'wrapped+values
(time
 (for ([i (in-range N)])
   (let-values ([(v k) (g2 i)])
     (k v))))

'impersonate/any
(time
 (for ([i (in-range N)])
   (h0 i)))

'impersonate
(time
 (for ([i (in-range N)])
   (h i)))

'chaperone
(time
 (for ([i (in-range N)])
   (j i)))

'chaperone+mark
(time
 (for ([i (in-range N)])
   (k i)))
