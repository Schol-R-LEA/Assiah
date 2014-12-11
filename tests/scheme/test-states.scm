#!r6rs
(import 
 (rnrs (6))
 (rnrs base (6))
 (rnrs io simple (6))
 (srfi :64)
 (assiah bootstrap state-types)
 (assiah bootstrap state-interfaces)
 (assiah bootstrap state-operations)
 (assiah bootstrap state-support)
 (assiah bootstrap conditions))

(define runner (test-runner-simple))

(test-with-runner runner 
		  (test-group "Tests of the state definition template macro and support functions"
			      (test-group "Basic state definition"
					  (define-state Bits (default 32) (states 16 32))
					  (test-assert (state? Bits))
			      (test-group "Basic state getter"
					  (define-state Bits (default 32) (states 16 32))
					  (test-equal (get-state Bits) 32))
			      (test-group "Basic state redefinition"
			      		  (define-state Bits (default 32) (states 16 32))
			      		  (set-state! Bits 16)
			      		  (test-equal (get-state Bits) 16)
			      ;; (test-group "Invalid default - can't test because it is an expand-time condition"
			      ;; 		  (test-error &invalid-state-violation
			      ;; 		   (define-state Bits (default 12) (states 16 32)))))
			      (test-group "Invalid state change"
			      		  (define-state Bits (default 16) (states 16 32))
			      		  (test-error &invalid-state-violation
			      			      (set-state! Bits 12)))))))
