#!r6rs

(library 
 (assiah bootstrap template-operations)
 (export get-state get-state-list 
	 field-table-contains? get-field-table-value get-field-table-default-value 
	 get-bit-field-value)
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

 (define field-table-contains?
   (lambda (table key)
     (hashtable-contains? (field-table-table table) key)))

 (define get-field-table-value 
   (lambda (table key)
     (hashtable-ref (field-table-table table) key '())))

  (define get-field-table-default-value 
    (lambda (table)
      (hashtable-ref (field-table-table table) (field-table-default-key table) '())))

 (define get-bit-field-value 
   (lambda (bit-field key)
     (get-field-table-value (bit-field-table bit-field) key))))
