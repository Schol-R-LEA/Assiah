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
      ((_ ?name ((?pattern => ?value)))
       (define name (list (cons '?pattern ?value))))
      ((_ ?name ((?pattern-0 => ?value-0) (?pattern-1 => ?value-1)))
       (define ?name (list (cons '?pattern-0 ?value-0) (cons '?pattern-1 ?value-1))))
      ((_ ?name ((?pattern-1 => ?value-1) (?pattern-2 => ?value-2) ... )))
       (define ?name 
        (let loop ((next-pattern ?pattern)
                   (next-value ?value))
          (list (cons next-pattern next-value)
                (loop (?pattern-2 ?value-2 ...))))))))
