#!r6rs

(library 
 (assiah bootstrap template-operations)
 (export add-error-reporting copy-parent-fields validate-state)
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

 (define-syntax add-error-reporting
   (syntax-rules (errors)
     ((_ ?who ?cond-ctor (errors ?error-state-0 ?error-state ...))
      (lambda (msg)
	(raise
	 (condition
	  (make-who-condition ?who)
	  (make-message-condition msg)
	  (?cond-ctor '?error-state-0 '?error-state ...))))))) 


 (define copy-parent-fields
   (lambda (parent)
     (caddr parent)))

 (define (validate-state new-state states-list reporter)
   (unless (memv new-state states-list)
	   (reporter "selected default is not in the list of possible states"))))
