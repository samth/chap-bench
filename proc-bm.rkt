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


(define N 10000000)

'inlined
(time
 (for ([i (in-range N)])
   (e i)))

(define f #f)
(set! f e)

'plain
(time
 (for ([i (in-range N)])
   (f i)))

(define g #f)
(set! g (lambda (x) (check (f (check x)))))

'wrapped
(time
 (for ([i (in-range N)])
   (g i)))

(define g2 #f)
(set! g2 (lambda (x) (values (f (check x)) (lambda (y) (check y)))))

'wrapped+values
(time
 (for ([i (in-range N)])
   (let-values ([(v k) (g2 i)])
     (k v))))

(define h0 (impersonate-procedure f (lambda (x) (check x))))

'impersonate/any
(time
 (for ([i (in-range N)])
   (h0 i)))

(define h (impersonate-procedure f
                                 (lambda (x)
                                   (values (lambda (y) (check y)) (check x)))))

'impersonate
(time
 (for ([i (in-range N)])
   (h i)))

(define j (chaperone-procedure f
                               (lambda (x)
                                 (values (lambda (y) (check y)) (check x)))))

'chaperone
(time
 (for ([i (in-range N)])
   (j i)))

(define k (chaperone-procedure f
                               (lambda (x)
                                 (values (lambda (y) (check y)) (check x)))
                               impersonator-prop:application-mark
                               '(1 . 2)))

'chaperone+mark
(time
 (for ([i (in-range N)])
   (k i)))
