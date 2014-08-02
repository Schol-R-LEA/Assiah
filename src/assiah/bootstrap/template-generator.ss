#!r6rs

(library 
 (assiah bootstrap template-generator)
 (export define-field-pattern get-field-width)
 (import
  (rnrs base (6))
  (rnrs lists (6))
  (rnrs syntax-case (6))
  (rnrs io simple (6))
  (rnrs records syntactic (6)))


 (define-syntax define-field-pattern
  (lambda (x)
    (syntax-case x (width default =>)
      ((_ name (width w) ((p-0 ... => value) ... (default => value-n)))
       #'(define name `((width . w) (((p-0 ...) . value) ...
				     (default . value-n)))))
      ((_ name (width w) ((p-0 ... => value) ...))
       #'(define name `((width . w) (((p-0 ...) . value) ...))))
      )))

 (define get-field-width
   (lambda (field)
     (cond ((null? field) '())
	   ((and (list? field) 
		 (pair? (car field))
		 (eq? 'width (caar field))
		 (cdar field)))
	   (else (get-field-width (cdr field)))))))


					; (define-syntax define-field
					;   (lambda (x)
					;     (let ()
					;       (syntax-case x (parent width bit-index)
					;	 ((
