#!r6rs

(library 
 (assiah bootstrap template-operations)
 (export get-state get-state-list
	 get-field-width get-field-bit-index 
	 get-value-list-width get-value)
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
 
 (define get-state 
   (lambda (state)
     (car state)))

(define get-state-list
  (lambda (state)
    (cdr state)))

 (define get-field-width
   (lambda (field)
     (cdar field)))

 (define get-field-bit-index
   (lambda (field)
     (cdadr field)))

 (define get-value-list-width 
   (lambda (vallist)
     (caadar vallist)))

 (define get-value 
   (lambda (vallist key)
     (hashtable-ref (cadr vallist) key '()))))
