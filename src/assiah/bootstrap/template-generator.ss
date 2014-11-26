#!r6rs

(library 
 (assiah bootstrap template-generator)
 (export define-field-pattern get-field-width define-value-list get-value-list-width)
 (import
  (rnrs base (6))
  (rnrs lists (6))
  (rnrs syntax-case (6))
  (rnrs io simple (6))
  (rnrs hashtables (6))
  (rnrs records syntactic (6)))


 (define-syntax define-field-pattern
   (syntax-rules (width default =>)
     ((_ name (width w) ((p-0 ... => value) ... (default => value-n)))
      (define name '((width . w) (((p-0 ...) . value) ...
				  (default . value-n)))))
     ((_ name (width w) ((p-0 ... => value) ...))
      (define name '((width . w) (((p-0 ...) . value) ...))))
     ))

 (define get-field-width
   (lambda (field)
     (cond ((null? field) '())
	   ((and (list? field) 
		 (pair? (car field))
		 (eq? 'width (caar field))
		 (cdar field)))
	   (else (get-field-width (cdr field))))))

 
 (define-syntax define-field
   (syntax-rules (parent width bit-index =>)
     ((_ name (width w) (bit-index bi) ((p-0 ... => value-0) ... (default => value-n)))
      (define name '((width . w) 
		     (bit-index . bi) 
		     (((p-0 ...) . value) ...
		      (default . value-n)))))
     ((_ name (width w) (bit-index bi) ((p-0 ... => value-0) ...))
      (define name '((width . w) 
		     (bit-index . bi) 
		     (((p-0 ...) . value) ...))))
     ((_ name (parent super) (bit-index bi) ((p-0 ... => value-0) ... (default => value-n)))
      (define name '((width . #,(get-field-width super)) 
		     (bit-index . bi) 
		     (((p-0 ...) . value-0) ...
		      (default . value-n)))))
     ((_ name (parent super) (bit-index bi) ((p-0 ... => value-0) ... ))
      (define name '((width . #,(get-field-width super)) 
		     (bit-index . bi) 
		     (((p-0 ...) . value) ...))))))
 
 
 ;; (define-syntax define-value-list
 ;;   (lambda (x)
 ;;     (syntax-case x (width =>) 
 ;;       ((_ name (width w) ((hash-0 => pair-0) ...))
 ;; 	#`(define name  '((width . w)
 ;; 			  #,(let ((table (make-hashtable string-hash string=?)))
 ;; 			      #`(begin 
 ;; 				  (#,hashtable-set! #,table hash-0 pair-0) 
 ;; 				  ...)
 ;; 			      table)))))))


 (define-syntax define-value-list
   (syntax-rules (width =>)
     ((_ ?the-name (width . ?the-width) ((?key => ?val) ...))
      (define ?the-name
	`((width ?the-width)
	  ,(let ((table (make-hashtable string-hash string=?)))
	     (hashtable-set! table ?key ?val)
	     ...
	     table))))))

 (define (get-value-list-width vallist)
   (caadar vallist))

 )
