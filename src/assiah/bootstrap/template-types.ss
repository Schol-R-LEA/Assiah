#!r6rs

(library 
 (assiah bootstrap template-generator)
 (export field-table make-field-table field-table? field-table-table
	 bit-field make-bit-field bit-field? bit-field-width  bit-field-index bit-field-table)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs bytevectors (6))
  (rnrs hashtables (6))
  (rnrs exceptions (6))
  (rnrs conditions (6))
  (rnrs mutable-pairs (6))
  (rnrs records syntactic (6))
  (assiah bootstrap conditions))

 (define-record-type (field-table make-field-table field-table?)
   (fields default-key table)
   (protocol 
    (lambda (ctor)
      (lambda (default-key table-list)
	(let ((temp-table (make-hashtable equal-hash equal?))
	      (report-error (add-error-reporting
			     'make-field-table
			     make-invalid-table-entry-violation)))
	  (let loop ((remaining-elements table-list))
	    (cond ((null? remaining-elements) '())
		  ((not (list? remaining-elements))
		   (report-error "Table entries must be contained in a list."))				 
		  ((pair? (car  remaining-elements))
		   (hashtable-set! temp-table (caar remaining-elements) (cdar remaining-elements))
		   (loop (cdr remaining-elements)))
		  (else 		      
		   (report-error "Table entries must be passed as pairs."))))
	  (if (or (null? default-key)
		  (hashtable-contains? temp-table default-key))
	      (ctor default-key temp-table)
	      (report-error "Default key has no table entry.")))))))


 (define-record-type (bit-field make-bit-field bit-field?)
   (fields width index table)
   (protocol 
    (lambda (ctor)
      (lambda (bit-width bit-index table-list) 

	(let ((invalid-values (validate-field-values table-list bit-width))
	      (report-bad-table (add-error-reporting 'make-bit-field
						     make-invalid-field-table-violation))
	      (report-bad-entry (add-error-reporting 'make-bit-field
						     make-invalid-bit-width-violation)))
	  (cond ((not (field-table? table-list)) (report-bad-table "bit fields require a table of possible values"))
		((null? invalid-values)
		 (ctor bit-width bit-index table-list))
		(else (report-bad-entry "bit fields require integer values in the size of the bit width"))))))))
 


 (define validate-field-values
   (lambda (table width)
     (let ((table-keys (hashtable-keys table)))
       (let test-key-values ((key-list table-keys))
	 (if (null? key-list) 
	     '()
	     (let ((value (hashtable-ref (car key-list)))
		   (rest-keys (cdr key-list)))
	       (if (not (in-bit-width value width))
		   (cons value (test-key-values rest-keys))
		   (test-key-values rest-keys))))))))


 (define in-bit-width
   (lambda (value width)
     (and (integer? value)
	  (>= value 0)
	  (<= value (binary-expansion width)))))

 (define binary-expansion 
   (lambda (width)
     (- (expt 2 width) 1)))


 (define-record-type (composite-field make-composite-field composite-field?)
   (fields width sub-field-list)
   (protocol
    (lambda (ctor)
      (let ((report-error (add-error-reporting 'make-composite-field make-invalid-bit-field-violation)))
	(lambda (bit-width sub-field-list-values)
	  ((ctor
	    bit-width
	    (let loop ((remaining-values sub-field-list-values))
	      (if (null? remaining-values)
		  sub-field-list-values
		  (if (bit-field? (car remaining-values))
		      (loop (cdr remaining-values))
		      (report-error
		       "The list of bit fields contained an element that was not a bit-field"))))))))))))

