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

(define-state Bits (default 16) (states 16 32))

(set-state! Bits 12)
