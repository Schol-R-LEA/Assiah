#!r6rs
(import 
 (rnrs (6))
 (rnrs base (6))
 (rnrs io simple (6))
 (rnrs hashtables (6))
 (srfi :64)
 (assiah bootstrap field-types)
 (assiah bootstrap field-interfaces)
 (assiah bootstrap field-operations)
 (assiah bootstrap conditions))

(define runner (test-runner-simple))

(test-with-runner runner 	      
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
						      (make-field-table "This isn't a table entry")))
			      (test-group "Test of default key"
					  (define foo (make-field-table 'c
									'((a . 1)
									  (b . 2)
									  (c . 3))))
					  (test-equal 'c (get-default-key foo))))
		  
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

			      (test-group "multiple value handling"
			      		  (define-field-table foo
			      		    (((bar "baz" quux) => 2)
			      		     (bar => 1)))
					  (test-assert (field-table? foo))
			      		  (test-equal (get-field-table-value foo '(bar "baz" quux)) 2)
			      		  (test-equal (get-field-table-value foo 'bar) 1))
			      (test-group "Test of default key"
			      		  (define-field-table foo (default quux)
			      		    (((bar "baz" quux) => 2)
			      		     (bar => 1)
					     (quux => 4)))
					    (test-assert (field-table? foo))
					    (test-assert (field-table-contains? foo 'quux))
					    (test-equal 'quux (get-default-key foo))
					    (test-equal (get-field-table-value foo (get-default-key foo)) 4)
					    (test-equal (get-field-table-default-value foo) 4)))


		  (test-group "Tests of the supporting bit-field validation functions"
			      (test-group "Test for bit expansion"
					  (test-equal #b111 (binary-expansion 3)))
			      (test-group "Test for whether the value is with the bit width"
					  (test-assert (in-bit-width? 4 #b111))
					  (test-assert (not (in-bit-width? 8 3)))
					  (test-assert (not (in-bit-width? 'a 3)))
					  (test-assert (not (in-bit-width? -5 3))))
			     (test-group "Test for successful table entry value validation"
					 (define bar (make-field-table '()
								       '((a . 1)
									 (b . 2)
									 (c . 3)))) 
					 (test-equal '() (validate-field-values bar 3)))
			     (test-group "Test for unsuccessful table entry value validation"
					 (define bar (make-field-table '()
								       '((a . 1)
									 (b . 8)
									 (c . 3))))
					 (test-equal '(8) (validate-field-values bar 3))))

		  (test-group "Tests of the underlying bit-field record type"
			      (test-group "Test for build a bit-field and retrieving a value"
					  (define bar (make-field-table '()
									'((a . 1)
									  (b . 2)
									  (c . 3))))
					  (define foo (make-bit-field 3 0 bar))
					  (test-assert (bit-field? foo))
					  (test-equal (bit-field-width foo) 3)
					  (test-equal 2 (get-bit-field-value foo 'b)))
			      (test-group "Test for reporting a value too large for bit field"
					  (define bar (make-field-table '()
									'((a . 1)
									  (b . 9)
									  (c . 3))))
					  (test-error &invalid-bit-width-violation
						      (make-bit-field 3 0 bar)))))
