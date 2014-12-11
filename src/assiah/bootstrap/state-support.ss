#!r6rs

(library 
 (assiah bootstrap state-support)
 (export validate-state)
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

 (define (validate-state new-state states-list reporter)
   (unless (memv new-state states-list)
	   (reporter "selected default is not in the list of possible states"))))
