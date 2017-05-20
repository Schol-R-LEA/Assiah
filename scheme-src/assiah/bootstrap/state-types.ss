#!r6rs

(library 
 (assiah bootstrap state-types)
 (export make-state state? get-state internal-set-state! get-state-list)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs records syntactic (6)))

 (define-record-type (state make-state state?)
   (fields (mutable state get-state internal-set-state!) (immutable state-list get-state-list))))

