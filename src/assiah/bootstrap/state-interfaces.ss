#!r6rs

(library 
 (assiah bootstrap state-interfaces)
 (export define-state set-state!)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs syntax-case (6))
  (assiah bootstrap conditions)
  (for (assiah bootstrap conditions) expand)
  (assiah bootstrap state-types)
  (for (assiah bootstrap state-types) expand)
  (assiah bootstrap state-support)
  (for (assiah bootstrap state-support) expand))


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
	    #'(define ?state-name (make-state ?default (list ?state-0 ?state-n ...)))))))))

 (define-syntax set-state!
   (lambda (statement)
     (syntax-case statement ()
       ((_ ?state ?new-value)
	#`(let* ((new-value (syntax->datum ?new-value))
		 (state (syntax->datum ?state))
		 (state-list (get-state-list state))
		 (report-error 
		  (add-error-reporting 'set-state! 
				       make-invalid-state-violation 
				       (errors #,statement ?new-value))))
	    (validate-state new-value state-list report-error)
	    (internal-set-state! ?state ?new-value)))))))
