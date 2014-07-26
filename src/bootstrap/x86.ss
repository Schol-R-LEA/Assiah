#!r6rs

(library 
 (assiah bootstrap x86)
 (export x86-word-sizes x86-instruction-fields x86-opcode-fields x86-mnemonics)
 (import
  (rnrs base (6))
  (rnrs enums (6))
  (rnrs hashtables (6))
  (rnrs lists (6))
  (rnrs records syntactic (6))
  (rnrs exceptions (6))
  (rnrs conditions (6))
  (assiah bootstrap opcodes))
 
 (define-enumeration 
   lockable-states
   (NO REG-DEST-ONLY MEM-DEST-ONLY ALLOWED REQUIRED) 
   lockable-state-set)
 
  (define-enumeration 
   restricted-states
   (RING-0 RING-3 INT-FLAG) 
   restricted-state-set)
 
 (define x86-word-sizes (make-hashtable symbol-hash eq?)) 
 
 (define op-size-override #x66)
 (define addr-size-override #x67)
 
 (define META-OFFSET-GROUP-A #x3A)
 (define META-OFFSET-GROUP-B #x38)
 
 (define x86-prefixes (make-hashtable symbol-hash eq?))
 (define x86-segment-overrides (make-hashtable symbol-hash eq?))
 (define x86-branch-pred-prefixes (make-hashtable symbol-hash eq?))
 
 (define-record-type x86-opcode-fields
   (parent opcode-fields)
   (fields opcode-size))
 
 (define-record-type x86-condition-fields
   (parent opcode-sub-fields)
   (fields bit-field))
 
 (define x86-opcode-sub-field-set (make-hashtable symbol-hash eq?))
 
 (define-record-type x86-opcode-field-set
   (fields opcode field-signature arg-sizes))
 
 (define-record-type x86-opcode
   (fields mandatory-prefix alt-offset meta-offset secondary-opcode opcode r/m lockable restricted))
 
 (define i8086-mnemonics (make-hashtable symbol-hash eq?))
 (define i80186-mnemonics (make-hashtable symbol-hash eq?))
 (define i80286-mnemonics (make-hashtable symbol-hash eq?))
 (define i80287-mnemonics (make-hashtable symbol-hash eq?))
 (define i80386-mnemonics (make-hashtable symbol-hash eq?))
 (define i80387-mnemonics (make-hashtable symbol-hash eq?))
 (define i80486-mnemonics (make-hashtable symbol-hash eq?))
 (define pentium-mnemonics (make-hashtable symbol-hash eq?))
 (define ppro-mnemonics (make-hashtable symbol-hash eq?))
 (define MMX-mnemonics (make-hashtable symbol-hash eq?))
 (define pII-mnemonics (make-hashtable symbol-hash eq?))
 (define pIII-mnemonics (make-hashtable symbol-hash eq?))
 (define pIV-mnemonics (make-hashtable symbol-hash eq?))
 (define core-mnemonics (make-hashtable symbol-hash eq?))
 (define core2-mnemonics (make-hashtable symbol-hash eq?))
 (define SSE-mnemonics (make-hashtable symbol-hash eq?))
 (define SSE2-mnemonics (make-hashtable symbol-hash eq?))
 (define SSE3-mnemonics (make-hashtable symbol-hash eq?))
 (define SSSE3-mnemonics (make-hashtable symbol-hash eq?))
 (define SSE4-mnemonics (make-hashtable symbol-hash eq?))
 
 (define x86-mnemonics '(i8086-mnemonics i80186-mnemonics i80286-mnemonics i80287-mnemonics
                                         i80386-mnemonics i80387-mnemonics i80486-mnemonics
                                         pentium-mnemonics ppro-mnemonics MMX-mnemonics pII-mnemonics
                                         pIII-mnemonics pIV-mnemonics
                                         core-mnemonics core2-mnemonics
                                         SSE-mnemonics SSE2-mnemonics SSE3-mnemonics SSSE3-mnemonics
                                         SSE4-mnemonics SSE41-mnemonics SSE42-mnemonics))
 
 (hashtable-set! x86-opcode-sub-field-set 'R+ (make-opcode-sub-fields 3 0))
 (hashtable-set! x86-opcode-sub-field-set 'W (make-opcode-sub-fields 1 0))
 (hashtable-set! x86-opcode-sub-field-set 'S (make-opcode-sub-fields 1 1))
 (hashtable-set! x86-opcode-sub-field-set 'D (make-opcode-sub-fields 1 1))
 (hashtable-set! x86-opcode-sub-field-set 'SR (make-opcode-sub-fields 2 3))
 (hashtable-set! x86-opcode-sub-field-set 'SRE (make-opcode-sub-fields 3 3))
 (hashtable-set! x86-opcode-sub-field-set 'MF (make-opcode-sub-fields 2 1))
 (hashtable-set! x86-opcode-sub-field-set 'OF (make-x86-condition-fields 4 0 (0 0 0 0)))
 (hashtable-set! x86-opcode-sub-field-set 'NO (make-x86-condition-fields 4 0 (0 0 0 1)))
 (hashtable-set! x86-opcode-sub-field-set 'B (make-x86-condition-fields 4 0  (0 0 1 0)))
 (hashtable-set! x86-opcode-sub-field-set 'AE (make-x86-condition-fields 4 0 (0 0 1 1))) 
 (hashtable-set! x86-opcode-sub-field-set 'EQ (make-x86-condition-fields 4 0 (0 1 0 0)))
 (hashtable-set! x86-opcode-sub-field-set 'NE (make-x86-condition-fields 4 0 (0 1 0 1)))
 (hashtable-set! x86-opcode-sub-field-set 'NA (make-x86-condition-fields 4 0 (0 1 1 0)))
 (hashtable-set! x86-opcode-sub-field-set 'A (make-x86-condition-fields 4 0  (0 1 1 1))) 
 (hashtable-set! x86-opcode-sub-field-set 'SN (make-x86-condition-fields 4 0  (1 0 0 0)))
 (hashtable-set! x86-opcode-sub-field-set 'NS (make-x86-condition-fields 4 0 (1 0 0 1)))
 (hashtable-set! x86-opcode-sub-field-set 'P (make-x86-condition-fields 4 0  (1 0 1 0)))
 (hashtable-set! x86-opcode-sub-field-set 'NP (make-x86-condition-fields 4 0 (1 0 1 1))) 
 (hashtable-set! x86-opcode-sub-field-set 'LT (make-x86-condition-fields 4 0 (1 1 0 0)))
 (hashtable-set! x86-opcode-sub-field-set 'GE (make-x86-condition-fields 4 0 (1 1 0 1)))
 (hashtable-set! x86-opcode-sub-field-set 'LE (make-x86-condition-fields 4 0 (1 1 1 0)))
 (hashtable-set! x86-opcode-sub-field-set 'GT (make-x86-condition-fields 4 0 (1 1 1 1)))
 
 (hashtable-set! x86-word-sizes 'NONE 0)
 (hashtable-set! x86-word-sizes 'BYTE 1)
 (hashtable-set! x86-word-sizes 'WORD 2)
 (hashtable-set! x86-word-sizes 'DOUBLE-WORD 4)
 (hashtable-set! x86-word-sizes 'QUAD-WORD 8)
 (hashtable-set! x86-word-sizes 'OCT-WORD 16)
 (hashtable-set! x86-word-sizes 'HEX-WORD 32)
 (hashtable-set! x86-word-sizes 'HALF-K 64) 
 (hashtable-set! x86-word-sizes 'SYSTEM-HALF-WORD '(1 2))
 (hashtable-set! x86-word-sizes 'SYSTEM-WORD '(2 4 8))
 (hashtable-set! x86-word-sizes 'FP-STATE '(94 108))
 (hashtable-set! x86-word-sizes 'FP80 10)
 (hashtable-set! x86-word-sizes 'FP96 12)
 
 (hashtable-set! x86-prefixes 'LOCK #xF0)
 (hashtable-set! x86-prefixes 'REPNE #xF2)
 (hashtable-set! x86-prefixes 'REPNZ #xF2)
 (hashtable-set! x86-prefixes 'REP #xF3)
 (hashtable-set! x86-prefixes 'REPE #xF3)
 (hashtable-set! x86-prefixes 'REPZ #xF3) 
 
 (hashtable-set! x86-branch-pred-prefixes 'BRT #x2E)  ; 'branch taken' strong hint
 (hashtable-set! x86-branch-pred-prefixes 'BRNT #x3E) ; 'branch not taken' weak hint
 
 (hashtable-set! x86-segment-overrides 'CS #x2E)
 (hashtable-set! x86-segment-overrides 'SS #x36)
 (hashtable-set! x86-segment-overrides 'DS #x3E)
 (hashtable-set! x86-segment-overrides 'ES #x26)
 (hashtable-set! x86-segment-overrides 'FS #x64)
 (hashtable-set! x86-segment-overrides 'GS #x65))
