#!r6rs

(library 
 (assiah bootstrap fields)
 (export define-field-table field-table? field-table-contains? get-field-table-value get-field-table-default-value 
         define-bit-field get-bit-field-value)
 (import
  (rnrs (6))
  (rnrs base (6))
  (assiah bootstrap field-types)
  (assiah bootstrap field-operations)
  (assiah bootstrap field-intefaces)))
