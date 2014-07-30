(library 
  (assiah bootstrap telpate-generator)
  (export define-pattern define-property define-value define-state 
          define-option define-field define-field-pattern
          exclude)
  (import
    (rnrs base (6))
    (rnrs lists (6))
    (rnrs records syntactic (6)))
    
  (define-syntax define-pattern
    (syntax-rules (?name => ?pattern ?value)
      ((define-pattern ?name ((?pattern => ?value) ... )))
       ())))
