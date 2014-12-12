#!r6rs

(library 
 (assiah bootstrap template-operations)
 (export field-table-contains? get-field-table-value get-field-table-default-value 
	 get-bit-field-value
	 get-sub-field get-sub-field-value)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs hashtables (6))
  (assiah bootstrap field-types))

 (define field-table-contains?
   (lambda (table key)
     (hashtable-contains? (get-field-table table) key)))

 (define get-field-table-value 
   (lambda (table key)
     (hashtable-ref (get-field-table table) key '())))

  (define get-field-table-default-value 
    (lambda (table)
      (hashtable-ref (get-field-table table) (get-default-key table) '())))

 (define get-bit-field-value 
   (lambda (bit-field key)
     (get-field-table-value (bit-field-table bit-field) key)))

 (define get-sub-field
   (lambda (c-field field-name)
     (hashtable-ref (get-subfield-table c-field) field-name '())))

 (define get-sub-field-value
   (lambda (c-field field-name key)
     (get-bit-field-value (get-sub-field c-field field-name) key))))
