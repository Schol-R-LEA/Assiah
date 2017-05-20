#!r6rs

(import
 (rnrs base (6))
 (rnrs io simple (6))
 (rnrs syntax-case (6))
 (rnrs records syntactic (6)))

 (define-syntax %test-record-define
   (lambda (x)
     (syntax-case x ()
       ((_ type (field-name index getter setter) ...)
	(identifier? #'type)
	#'(define-record-type type
	    (fields (mutable field-name getter setter) ...))))))

(%test-record-define 
 my-test
 (test-1 1 test-1 test-1!)
 (pass-count 2 test-runner-pass-count test-runner-pass-count!)
 (fail-count 3 test-runner-fail-count test-runner-fail-count!))

(write my-test)
(newline)

(define foo (make-my-test 'bar 'baz 'quux))
(write foo)
(newline)
(write (test-1 foo))
(newline)
(test-1! foo 'flarp)
(write (test-1 foo))
(newline)
(write (test-runner-pass-count foo))
(newline)
(test-runner-pass-count! foo 'blink)
(write (test-runner-pass-count foo))
(newline)
(write (test-runner-fail-count foo))
(newline)
(test-runner-fail-count! foo 'blink)
(write (test-runner-fail-count foo))
(newline)
