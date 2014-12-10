#!r6rs
(import 
 (rnrs (6))
 (rnrs base (6))
 (rnrs io simple (6))
 (rnrs hashtables (6))
 (srfi :64)
 (assiah bootstrap template-types)
 (assiah bootstrap template-generator)
 (assiah bootstrap template-operations)
 (assiah bootstrap conditions))

(define runner (test-runner-simple))

(test-with-runner runner 
		  (test-group "Tests of the state definition template macro and support functions"
			      (test-group "Basic state definition"
					  (define-state Bits (default 32) (states 16 32))
					  (define bits-0 (cons 32 (list 16 32)))
					  (test-equal Bits bits-0))
			      (test-group "Basic state getter"
					  (define-state Bits (default 32) (states 16 32))
					  (test-equal (get-state Bits) 32))
			      (test-group "Basic state redefinition"
			      		  (define-state Bits (default 32) (states 16 32))
			      		  (define bits-0 (cons 16 (list 16 32)))
			      		  (set-state! Bits 16)
			      		  (test-equal Bits bits-0))
			      ;; (test-group "Invalid default - can't test because it is an expand-time condition"
			      ;; 		  (test-error &invalid-state-violation
			      ;; 		   (define-state Bits (default 12) (states 16 32)))))
			      (test-group "Invalid state change"
			      		  (define-state Bits (default 16) (states 16 32))
			      		  (test-error &invalid-state-violation
			      			      (set-state! Bits 12))))		      

		  (test-group "Tests of the underlying field-table record type"
			      (test-group "Test for build a field-table and retrieving a value"
					  (define foo (make-field-table '()
									'((a . 1)
									  (b . 2)
									  (c . 3))))
					  (test-assert (field-table? foo))
					  (test-equal 2 (get-field-table-value foo 'b)))
			      (test-group "Test invalid data for table creation"
					  (test-error &invalid-table-entry-violation
						      (make-field-table '()
									'((a . 1)
									  (b . 2)
									  c)))
					  (test-error &invalid-table-entry-violation
						      (make-field-table "This isn't a table entry"))))
		  

		  (test-group "Tests of the define-field-table template macro"
			      (test-group "basic single-value handling"
					  (define-field-table foo
					    ((bar => 2)))
					  (test-assert (field-table? foo))
					  (test-equal (get-field-table-value foo 'bar) 2))

			      (test-group "basic string-pattern handling"
					  (define-field-table foo
					    (("bar" => 2)))
					  (test-assert (field-table? foo))
					  (test-equal (get-field-table-value foo "bar") 2))

			      (test-group "mixed value and default handling"
			      		  (define-field-table foo
			      		    (((bar "baz" quux) => 2)
			      		     (bar => 1)))
			      		  (test-equal (get-field-table-value foo '(bar "baz" quux)) 2)
			      		  (test-equal (get-field-table-value foo 'bar) 1))))
