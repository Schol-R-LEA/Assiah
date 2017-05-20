#!r6rs

(import
 (rnrs (6))
 (rnrs base (6))
 (rnrs syntax-case (6))
 (rnrs io simple (6))
 (rnrs mutable-pairs (6)))
  
(define-syntax clear!
  (lambda (statement)
    (syntax-case statement ()
      ((_ ?x)
       #'(set! ?x 0)))))

(define a 42)

(clear! a)
(display a)
(newline)
