#!r6rs

(library 
 (assiah bootstrap template-generator)
 (export define-state set-state! 
	 define-field-table define-bit-field)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs hashtables (6))
  (rnrs conditions (6))
  (rnrs syntax-case (6))
  (rnrs mutable-pairs (6))
  (for (rnrs mutable-pairs (6)) expand)
  (rnrs records syntactic (6))
  (for (rnrs records syntactic (6)) expand)
  (assiah bootstrap conditions)
  (for (assiah bootstrap conditions) expand)
  (assiah bootstrap template-types)
  (for (assiah bootstrap template-types) expand)
  (assiah bootstrap template-operations)
  (for (assiah bootstrap template-operations) expand)
  (assiah bootstrap template-support)
  (for (assiah bootstrap template-support) expand))



 (define-syntax define-state
   (lambda (statement)
     (let ((report-error 
	    (add-error-reporting 'define-state 
				 make-invalid-state-violation 
				 (errors statement #'?default)))) 		   
       (syntax-case statement (default states)
	 ((_ ?state-name (default ?default) (states ?state-0 ?state-n ...))
	  (let ((default-value (syntax->datum #'?default))
		(state-list (syntax->datum #'(?state-0 ?state-n ...))))
	    (validate-state default-value state-list report-error)
	    #'(define ?state-name (cons ?default (list ?state-0 ?state-n ...)))))))))

 (define-syntax set-state!
   (lambda (statement)
     (syntax-case statement ()
       ((_ ?state ?new-value)
	#`(let* ((new-value (syntax->datum ?new-value))
		 (state (syntax->datum ?state))
		 (state-list (cdr state))
		 (report-error 
		  (add-error-reporting 'set-state! 
				       make-invalid-state-violation 
				       (errors #,statement ?new-value))))
	    (validate-state new-value state-list report-error)
	    (set-car! ?state ?new-value))))))



 (define-syntax define-field-table
   (syntax-rules (default =>)
     ((_ ?name (default => ?default-key) ((?p-0 => ?value) ... ))
      (define ?name (make-field-table ?default-key '((?p-0 . ?value) ... ))))
     ((_ ?name ((?p-0 => ?value) ...))
      (define ?name (make-field-table '() '((?p-0 . ?value) ...))))))



 (define-syntax define-bit-field
   (syntax-rules (width bit-index parent =>)
     ((_ ?name (width ?w) (bit-index ?bi) (parent ?super))
      (define ?name (make-bit-field ?w ?bi ?super))))))


