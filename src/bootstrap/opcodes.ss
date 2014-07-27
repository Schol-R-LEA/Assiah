#!r6rs

(library 
 (assiah bootstrap opcodes)
 (export instruction make-instruction instruction? 
         opcode-sub-fields make-opcode-sub-fields opcode-sub-fields? 
         opcode-format make-opcode-format opcode-format?)
 (import
  (rnrs base (6))
  (rnrs enums (6))
  (rnrs hashtables (6))
  (rnrs lists (6))
  (rnrs records syntactic (6)))
 
 (define-record-type (instruction make-instruction instruction?)
   (fields mnemonic opcode-format-list))
 
  (define-record-type (opcode-format make-opcode-format opcode-format?)
   (fields opcode opcode-sub-field-map)))
 
 (define-record-type (opcode-sub-fields make-opcode-sub-fields opcode-sub-fields?)
   (fields size bit-index))
 
