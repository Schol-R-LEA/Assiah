(library 
  (assiah bootstrap telpate-generator)
  (export define-pattern define-property define-value define-state 
          define-option define-field define-field-pattern
          exclude)
  (import
    (rnrs base (6))
    (rnrs lists (6))
    (rnrs records syntactic (6)))
    
  (define-syntax define-field-pattern
    (syntax-rules (width =>)
      ((_ ?name (width ?size) ((?pattern => ?value)))
       (define ?name (list ?size (cons '?pattern ?value))))
      ((_ ?name (width ?size) ((?pattern-0 => ?value-0) (?pattern-1 => ?value-1)))
       (define ?name (list ?size (cons '?pattern-0 ?value-0) (cons '?pattern-1 ?value-1)))))))
