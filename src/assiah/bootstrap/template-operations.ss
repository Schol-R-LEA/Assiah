#!r6rs

(library 
 (assiah bootstrap template-operations)
 (export get-state get-state-list get-field-table-value get-bit-field-value)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs lists (6))
  (rnrs io simple (6))
  (rnrs hashtables (6))
  (rnrs conditions (6))
  (rnrs syntax-case (6))
  (rnrs records syntactic (6))
  (assiah bootstrap conditions)
  (assiah bootstrap template-types))
 
 (define get-state 
   (lambda (state)
     (car state)))

 (define get-state-list
   (lambda (state)
     (cdr state)))

 (define get-field-table-value 
   (lambda (table key)
     (hashtable-ref (field-table-table table) key '())))

 (define get-bit-field-value 
   (lambda (bit-field key)
     (hashtable-ref (bit-field-table bit-field) key '()))))
