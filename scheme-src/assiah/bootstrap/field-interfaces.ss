#!r6rs

(library 
 (assiah bootstrap field-interfaces)
 (export define-field-table define-field)
 (import
  (rnrs (6))
  (rnrs base (6))
  (assiah bootstrap conditions)
  (for (assiah bootstrap conditions) expand)
  (assiah bootstrap field-types)
  (for (assiah bootstrap field-types) expand)
  (assiah bootstrap field-operations)
  (for (assiah bootstrap field-operations) expand))

 (define-syntax define-field-table
   (syntax-rules (default =>)
     ((_ ?name (default ?default-key) ((?p-0 => ?value) ... ))
      (define ?name (make-field-table '?default-key '((?p-0 . ?value) ... ))))
     ((_ ?name ((?p-0 => ?value) ...))
      (define ?name (make-field-table '() '((?p-0 . ?value) ...))))))


 (define-syntax define-field
   (syntax-rules (width bit-index table sub-fields)
     ((_ ?name (width ?w) (bit-index ?bi) (table ?super))
      (define ?name (make-bit-field ?w ?bi ?super)))
     ((_ ?name (width ?w) (sub-fields ?field-0 ...))
      (define ?name (make-composite-field ?w `((,'?field-0 . ?field-0) ...)))))))


