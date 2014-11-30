#!r6rs

(library 
 (assiah bootstrap template-generator)
 (export define-state get-state set-state! 
	 define-field-pattern define-field get-field-width get-field-bit-index 
	 define-value-list get-value-list-width)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs hashtables (6))
  (rnrs conditions (6))
  (rnrs syntax-case (6))
  (rnrs mutable-pairs (6))
  (for (rnrs mutable-pairs (6)) expand)
  (assiah bootstrap conditions)
  (for (assiah bootstrap conditions) expand)
  (assiah bootstrap template-operations)
  (for (assiah bootstrap template-operations) expand)
  (assiah bootstrap template-support)
  (for (assiah bootstrap template-support) expand))

 (define-syntax define-state
   (lambda (statement)
     (let* ((who 'define-state)
	    (report-error
	     (lambda (msg subform)
	       (raise
		(condition
		 (make-who-condition who)
		 (make-message-condition msg)
		 (make-invalid-state-violation statement subform)))))) 		   
       (syntax-case statement (default states)
	 ((_ ?state-name (default ?default) (states ?state-0 ?state-n ...))
	  (let ((default-value (syntax->datum #'?default))
		(state-list (syntax->datum #'(?state-0 ?state-n ...))))
	    (validate-state default-value state-list report-error)
	    #'(define ?state-name (cons ?default (list ?state-0 ?state-n ...)))))))))

 (define-syntax set-state!
   (syntax-rules ()
     ((_ ?state ?new-value)
      (let* ((who 'set-state!)
	     (new-value (syntax->datum ?new-value))
	     (state (syntax->datum ?state))
	     (state-list (cdr state))
	     (statement "failed (set-state!)")
	     (report-error
	      (lambda (msg subform)
		(raise
		 (condition
		  (make-who-condition who)
		  (make-message-condition msg)
		  (make-invalid-state-violation statement subform))))))
	(validate-state new-value state-list report-error)
	(set-car! ?state ?new-value)))))


 (define-syntax define-field-pattern
   (syntax-rules (width default =>)
     ((_ ?name (width ?w) ((?p-0 ... => ?value) ... (default => ?value-n)))
      (define ?name '((width . ?w) (((?p-0 ...) . ?value) ...
				  (default . ?value-n)))))
     ((_ ?name (width ?w) ((?p-0 ... => ?value) ...))
      (define ?name '((width . ?w) (((?p-0 ...) . ?value) ...))))
     ))
 
 (define-syntax define-field
   (syntax-rules (parent width bit-index =>)
     ((_ ?name (width ?w) (bit-index ?bi) ((?p-0 ... => ?value-0) ... (default => ?value-n)))
      (define ?name '((width . ?w) 
		      (bit-index . ?bi) 
		      (((?p-0 ...) . ?value-0) ...
		       (default . ?value-n)))))
     ((_ ?name (width ?w) (bit-index ?bi) ((?p-0 ... => ?value-0) ...))
      (define name '((width . ?w) 
		     (bit-index . ?bi) 
		     (((?p-0 ...) . ?value-0) ...))))
     ((_ ?name (parent ?super) (bit-index ?bi))
      (define ?name '((width . #,(get-field-width ?super)) 
		      (bit-index . ?bi) 
		      (#,(copy-parent-fields ?super)))))))


 (define-syntax define-value-list
   (syntax-rules (width =>)
     ((_ ?the-name (width . ?the-width) ((?key => ?val) ...))
      (define ?the-name
	`((width ?the-width)
	  ,(let ((table (make-hashtable string-hash string=?)))
	     (hashtable-set! table ?key ?val)
	     ...
	     table))))))



 )