#!r6rs

(library 
 (thelema bootstrap opcodes)
 (export instruction opcode-sub-fields opcode-format)
 (import
  (rnrs base (6))
  (rnrs enums (6))
  (rnrs hashtables (6))
  (rnrs lists (6))
  (rnrs records syntactic (6)))
 
 (define-record-type instruction
   (fields mnemonic opcode-format-list))
 
 (define-record-type opcode-sub-fields
   (fields size bit-index))
 
 (define-record-type opcode-format
   (fields opcode opcode-sub-field-map))
