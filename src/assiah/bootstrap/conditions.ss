#!r6rs

(library 
 (assiah bootstrap conditions)
 (export &invalid-state-violation make-invalid-state-violation invalid-state-violation?)
 (import
  (rnrs base (6))
  (rnrs conditions (6))
  (rnrs records syntactic (6)))

 (define-condition-type &invalid-state-violation
   &syntax 
   make-invalid-state-violation invalid-state-violation?))
