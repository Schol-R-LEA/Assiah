#!r6rs

(library 
 (assiah bootstrap field-types)
 (export field-table make-field-table field-table? get-field-table get-default-key
	 bit-field make-bit-field bit-field? bit-field-width bit-field-index bit-field-table
	 validate-field-values in-bit-width? binary-expansion)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs hashtables (6))
  (rnrs exceptions (6))
  (rnrs conditions (6))
  (rnrs records syntactic (6))
  (assiah bootstrap conditions))

 (define-record-type (field-table make-field-table field-table?)
   (fields (immutable default-key get-default-key) (immutable table get-field-table))
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
		   (hashtable-set! temp-table 
				   (caar remaining-elements) 
				   (cdar remaining-elements))
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
		((null? invalid-values) (ctor bit-width bit-index table-list))
		(else (report-bad-entry "bit fields require integer values in the size of the bit width"))))))))
 

 (define validate-field-values
   (lambda (table width)
     (let* ((ht (get-field-table table))
	    (table-keys (hashtable-keys ht)))
       (let test-key-values ((key-list (vector->list table-keys)))
	 (cond ((null? key-list) '())
	       ((list? key-list)
		(let ((value (hashtable-ref ht (car key-list) '()))
		      (rest-keys (cdr key-list)))
		  (if (not (in-bit-width? value width))
		      (append (list value) (test-key-values rest-keys))
		      (test-key-values rest-keys))))
	       (else 
		(let ((value (hashtable-ref ht key-list '())))
		  (if (not (in-bit-width? value width))
		      value
		      '()))))))))

 (define in-bit-width?
   (lambda (value width)
     (and (integer? value)
	  (positive? value)
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
	  (let loop ((remaining-values sub-field-list-values)
	             (sum 0))
	    (cond
	      ((> sum bit-width)
	       (report-error "Sum of bit widths exceeds total size."))
	      ((null? remaining-values) 
	        (ctor bit-width sub-field-list-values))
              (else 
                (let* ((field (car remaining-values))
                       (w (bit-field-width field))
                       (s (bit-field-index field)))
                  (cond
                    ((> s (- bit-width 1))
                     (report-error "Bit Index out of bounds."))
                    ((bit-field? field)
		     (loop (cdr remaining-values) (+ sum w)))
		     (report-error
		       "The list of bit fields contained an element that was not a bit-field"))))))))))))

