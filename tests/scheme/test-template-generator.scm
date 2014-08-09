#!r6rs
(import 
 (rnrs base (6))
 (rnrs io simple (6))
 (srfi-64)
 (assiah bootstrap template-generator))

					; (test-group "Tests of the temple-generator library for Assiah"

(test-begin "basic default handling")
(define-field-pattern foo-0 (width 3)
  ((default => 0)))
(test-eqv foo-0 '((width . 3) (default . 0)))
(test-end "basic default handling")



(define-field-pattern foo-1 (width 3)
  ((bar => 2)))
(write foo-1)
(newline)

(define-field-pattern foo-2 (width 3)
  (("bar" => 2)))
(write foo-2)
(newline)


(define-field-pattern foo-3 (width 3)
  ((bar "baz" quux => 2)
   (bar => 1)
   (default => 0)))
(write foo-3)
(newline)
