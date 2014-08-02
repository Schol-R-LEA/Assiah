#!r6rs
(import (rnrs base (6))
        (rnrs io simple (6))
	(assiah bootstrap template-generator))

(write '(foo "bar" quux))
(newline)

(define-field-pattern foo-0 (width 3)
  ((default => 0)))
(write foo-0)
(newline)

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
