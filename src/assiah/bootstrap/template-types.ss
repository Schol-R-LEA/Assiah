#!r6rs

(library 
 (assiah bootstrap template-generator)
 (export field-table make-field-table field-table? get-field-table-width get-field-table-table
	 bit-field make-bit-field bit-field? get-bit-field-width  get-bit-field-index get-bit-field-table)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs hashtables (6))
  (rnrs conditions (6))
  (rnrs mutable-pairs (6))
  (rnrs records syntactic (6))
  (assiah bootstrap conditions))

 (define-record-type (field-table make-field-table field-table?)
   (fields (table))
   (protocol 
    (lambda (ctor)
      (lambda (table-list)
	((ctor
	  (let ((temp-table (make-hashtable equal-hash equal?)))
	    (let loop ((remaining-elements table-list))
	      (if (not (pair? (car table-list)))
		  '()
		  (begin
		    (hashtable-set! temp-table (caar table-list) (cdar tabel-list))
		    (loop (cdr table-list)))))
	    temp-table)))))))


 (define-record-type (bit-field make-bit-field bit-field?)
   (fields width index table)
   (protocol 
    (lambda (ctor)
      (lambda (bit-width bit-index table-list)
	(ctor
	 bit-width
	 bit-index
	 (if (field-table? table-list)
	     (let ((invalid-values (validate-field-values table-list bit-width))
		   (if (null? invalid-values)
		       field-table
		       ((add-error-report 'make-bit-field
					  make-invalid-bit-width-violation
					  (errors invalid-values))
			"bit fields require integer values in the size of the bit width")))
	       ((add-error-report 'make-bit-field
				  make-invalid-field-table-violation
				  (errors field-table)))
		"bit fields require a table of possible values"))))))))



 (define-record-type (composite-field make-composite-field composite-field?)
   (fields width sub-field-list)
   (protocol
    (lambda (ctor)
      (lambda (bit-width sub-field-list-values)
	((ctor
	  bit-width
	  (let loop ((remaining-values sub-field-list-values))
	    (if (null? remaining-values)
		sub-field-list-values
		(if (bit-field? (car remaining-values))
		    (loop (cdr remaining-values))
		    ((add-error-report 'make-composite-field
				       make-invalid-bit-field-violation
				       (errors (car remaining-values)))
		     "The list of bit fields contained an element that was not a bit-field"))))))))))
				     
