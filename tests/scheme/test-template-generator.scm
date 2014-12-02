#!r6rs
(import 
 (rnrs (6))
 (rnrs base (6))
 (rnrs io simple (6))
 (rnrs hashtables (6))
 (srfi :64)
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

		  (test-group "Tests of the define-field-pattern template macro"
			      (test-group "basic default handling"
					  (define-field-pattern foo-0 (width 3)
					    ((default => 0)))
					  (test-equal foo-0 '((width . 3) ((default . 0)))))

			      (test-group "basic single-value handling"
					  (define-field-pattern foo-1 (width 3)
					    ((bar => 2)))
					  (test-equal foo-1 '((width . 3) (((bar) . 2)))))

			      (test-group "basic string-pattern handling"
					  (define-field-pattern foo-2 (width 3)
					    (("bar" => 2)))
					  (test-equal foo-2 '((width . 3) ((("bar") . 2)))))

			      (test-group "mixed value and default handling"
					  (define-field-pattern foo-3 (width 3)
					    ((bar "baz" quux => 2)
					     (bar => 1)
					     (default => 0)))
					  (test-equal foo-3 '((width . 3) (((bar "baz" quux) . 2) ((bar) . 1) (default . 0))))))

		  (test-group "Test of whether you can add a hashtable to a list"
			      (let ((temp-table (make-hashtable string-hash string=?)))
				(hashtable-set! temp-table "CS" #x2E)
				(let ((t (list '(width . 8) temp-table)))
				  (test-eq temp-table (cadr t)))))

		  (test-group "Tests of the define-value template macro"
		  	      (test-group "single value handling" 
					; the syntax to be tested
		  			  (define-value-list SEGMENT-PREFIX (width 8)
		  			    (("CS" => #x2E)))

		  			  (let ((w (caar SEGMENT-PREFIX))
		  				(v (get-value-list-width SEGMENT-PREFIX))
		  				(t (cadr SEGMENT-PREFIX))
		  				(temp-table (make-hashtable string-hash string=?)))
		  			    (test-eq w 'width)
		  			    (test-eq v 8)
					    (test-assert (hashtable? t))
					    (test-assert (hashtable-contains? t "CS"))
					    (hashtable-set! temp-table "CS" #x2E)  			    
                                            (test-equal 
		  			     (hashtable-ref t "CS" #t)
		  			     (hashtable-ref temp-table "CS" #t))))))
