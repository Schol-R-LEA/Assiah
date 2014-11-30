#!r6rs

(library 
 (assiah bootstrap template-operations)
 (export get-state 
	 get-field-width get-field-bit-index 
	 get-value-list-width)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs lists (6))
  (rnrs io simple (6))
  (rnrs hashtables (6))
  (rnrs conditions (6))
  (rnrs syntax-case (6))
  (rnrs records syntactic (6))
  (assiah bootstrap conditions))
 
 (define (get-state state)
   (car state))

 (define get-field-width
   (lambda (field)
     (cdar field)))

 (define get-field-bit-index
   (lambda (field)
     (cdadr field)))

 (define (get-value-list-width vallist)
   (caadar vallist)))
