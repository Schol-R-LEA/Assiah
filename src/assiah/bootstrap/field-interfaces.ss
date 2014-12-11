#!r6rs

(library 
 (assiah bootstrap field-interfaces)
 (export define-field-table define-bit-field)
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


 (define-syntax define-bit-field
   (syntax-rules (width bit-index parent)
     ((_ ?name (width ?w) (bit-index ?bi) (parent ?super))
      (define ?name (make-bit-field ?w ?bi ?super))))))


