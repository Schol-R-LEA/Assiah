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

 (define copy-parent-fields
   (lambda (parent)
     (caddr parent)))

 (define (validate-state new-state states-list reporter)
   (unless (memv new-state states-list)
	   (reporter "selected default is not in the list of possible states"))))
