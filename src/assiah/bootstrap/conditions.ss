#!r6rs

(library 
 (assiah bootstrap conditions)
 (export
  add-error-reporting
  &invalid-state-violation make-invalid-state-violation invalid-state-violation?
  &invalid-table-entry-violation make-invalid-table-entry-violation invalid-table-entry-violation?
  &invalid-bit-field-violation make-invalid-bit-field-violation invalid-bit-field-violation?
  &invalid-bit-width-violation make-invalid-bit-width-violation invalid-bit-width-violation?
  &invalid-field-table-violation make-invalid-field-table-violation invalid-field-table-violation?)

 (import
  (rnrs base (6))
  (rnrs exceptions (6))
  (rnrs conditions (6))
  (rnrs records syntactic (6)))

 (define-syntax add-error-reporting
   (syntax-rules (errors)
     ((_ ?who ?cond-ctor)
      (lambda (msg)
	(raise
	 (condition
	  (make-who-condition ?who)
	  (make-message-condition msg)
	  (?cond-ctor)))))
     ((_ ?who ?cond-ctor (errors ?error-state-0 ...))
      (lambda (msg)
	(raise
	 (condition
	  (make-who-condition ?who)
	  (make-message-condition msg)
	  (?cond-ctor '?error-state-0 ...)))))))

 (define-condition-type &invalid-state-violation
   &syntax 
   make-invalid-state-violation invalid-state-violation?)

 (define-condition-type &invalid-table-entry-violation
   &lexical
   make-invalid-table-entry-violation invalid-table-entry-violation?)

 (define-condition-type &invalid-bit-field-violation
   &lexical
   make-invalid-bit-field-violation invalid-bit-field-violation?)

 (define-condition-type &invalid-bit-width-violation
   &lexical
   make-invalid-bit-width-violation invalid-bit-width-violation?)

 (define-condition-type &invalid-field-table-violation
   &lexical
   make-invalid-field-table-violation invalid-field-table-violation?))

