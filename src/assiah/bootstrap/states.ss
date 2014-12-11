#!r6rs

(library 
 (assiah bootstrap states)
 (export define-state get-state set-state! get-state-list)
 (import
  (rnrs (6))
  (rnrs base (6))
  (assiah bootstrap state-interface)
  (assiah bootstrap state-types))
