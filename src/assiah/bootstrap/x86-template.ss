(define-assembler-state Bits 32               ; default to 32-bit 
  (states 16 32))               

(define-value SEGMENT-PREFIX (width 8)
  (("CS" => #x2E) 
   ("SS" => #x36)
   ("DS" => #x3E)
   ("ES" => #x26)
   ("FS" => #x64)
   ("GS" => #x65)))

(define-pattern SEG-MODIFIER
  (("SEG" SEGMENT-PREFIX)))

(define-option OPT-SEG-MOD (SEG-MODIFIER NONE))

(define-instruction-state Using-Seg-Modifier NONE)

(define-instruction-state System-Word Bits)   ; default to the current BITS state

(define-instruction-state SYSTEM-INT
  (case (System-Word)
    ((16) INT-16)
    ((32) INT-32)))

					; 8-bit general-purpose registers
(define-field-pattern GPR-8 (width 3)
  (("AL" => #b000)
   ("CL" => #b001)
   ("DL" => #b010)
   ("BL" => #b011)
   ("AH" => #b100)
   ("CH" => #b101)
   ("DH" => #b110)
   ("BH" => #b111)))

					; 16-bit general-purpose registers
(define-field-pattern GPR-16 (width 3)
  (("AX" => #b000)
   ("CX" => #b001)
   ("DX" => #b010)
   ("BX" => #b011)
   ("SP" => #b100)
   ("BP" => #b101)
   ("SI" => #b110)
   ("DI" => #b111)))

					; 32-bit general-purpose registers
(define-field-pattern GPR-32 (width 3)  
  (("EAX" => #b000)
   ("ECX" => #b001)
   ("EDX" => #b010)
   ("EBX" => #b100)
   ("ESP" => #b100)
   ("EBP" => #b101)
   ("ESI" => #b110)
   ("EDI" => #b111)))


(define-field REG-8 (parent GPR-8) (bit-index 3))
(define-field REG-16 (parent GPR-16) (bit-index 3))
(define-field REG-32 (parent GPR-32) (bit-index 3))

(define-field R/M-8 (parent GPR-8) (bit-index 0))
(define-field R/M-16 (parent GPR-16) (bit-index 0))
(define-field R/M-32 (parent GPR-32) (bit-index 0))

(define-field INDEX-8 (parent (exclude ("AH") GPR-8)) (bit-index 3))
(define-field INDEX-16 (parent (exclude ("SP") GPR-16)) (bit-index 3))
(define-field INDEX-32 (parent (exclude ("ESP") GPR-32)) (bit-index 3))

(define-field BASE-8 (parent GPR-8) (bit-index 0))
(define-field BASE-16 (parent GPR-16) (bit-index 0))
(define-field BASE-32 (parent GPR-32) (bit-index 0))

(define-instruction-state SYSTEM-REG
  (case (System-Word)
    ((16) REG-16)
    ((32) REG-32)))

(define-option REG (REG-8 SYSTEM-REG))

(define-instruction-state SYSTEM-R/M
  (case (System-Word)
    ((16) R/M-16)
    ((32) R/M-32)))

(define-option R/M (R/M-8 SYSTEM-R/M))

(define-instruction-state SYSTEM-INDEX
  (case (System-Word)
    ((16) INDEX-16)
    ((32) INDEX-32)))

(define-option INDEX (INDEX-8 SYSTEM-INDEX))

(define-instruction-state SYSTEM-BASE
  (case (System-Word)
    ((16) BASE-16)
    ((32) BASE-32)))

(define-option BASE (BASE-8 SYSTEM-BASE))

(define-option DISP-8 (INT-8 EQUATE-8))
(define-option DISP-16 (INT-16 EQUATE-16))
(define-option DISP-32 (INT-32 EQUATE-32))

(define-instruction-state SYSTEM-DISP
  (case (System-Word)
    ((16) DISP-16)
    ((32) DISP-32)))

(define-option DISP (DISP-8 SYSTEM-DISP)) 

(define-option R/M-OR-DISP ((exclude ("BP" "EBP") SYSTEM-R/M) 
			    SYSTEM-INT))  

(define-pattern REF ("Ref" (OPT-SEG-MOD R/M-OR-DISP))                         ; (ADD EBX (REF EAX))
  (define-pattern REF-DISP-8 ("Ref" OPT-SEG-MOD SYSTEM-R/M DISP-8))            ; (ADD EBX (REF AL 2))
  (define-pattern REF-SYSTEM-DISP ("Ref" OPT-SEG-MOD SYSTEM-R/M SYSTEM-DISP)))  ; (ADD EBX (REF EAX 512)) 

(define-field SCALE (width 2) (bit-index 6)
  ("1" => #b00)
  ("2" => #b01)
  ("4" => #b10)
  ("8" => #b11))

(define-pattern SCALE-BARE ("Index" ("Scale" SYSTEM-INDEX SCALE))) 
					; (ADD EBX (INDEX (SCALE EDX 8)))
(define-pattern SCALE-W/O-DISP ("Index" OPT-SEG-MOD SYSTEM-BASE ("Scale" SYSTEM-INDEX SCALE)))  
					; (ADD EBX (INDEX EAX (SCALE EDX 8)))
(define-pattern SCALE-8 ("Index" OPT-SEG-MOD BASE-8 ("Scale" SYSTEM-INDEX SCALE) DISP))
					; (ADD EBX (INDEX AX (SCALE EDX 8) 4))
(define-pattern SYSTEM-SCALE ("Index" OPT-SEG-MOD SYSTEM-BASE ("Scale" SYSTEM-INDEX SCALE) DISP)) 
					; (ADD EBX (INDEX EAX (SCALE EDX 8) 4))
(define-pattern SCALE-W/O-BASE ("Index" ("Scale" SYSTEM-INDEX SCALE) DISP))  
					; (ADD EBX (INDEX (SCALE EDX 8) 4))

(define-option REF/SCALE (REF SCALE-BARE SCALE-W/O-DISP SCALE-W/O-BASE))
(define-option REF-8/SCALE-8 (REF-8 SCALE-8))
(define-option REF-SYS/SCALE-SYS (REF-SYSTEM-DISP SYSTEM-SCALE))

(define-field MOD (width 2) (index 6)                      
  ((REF/SCALE) => #b00)       
  ((REF-8/SCALE-8) => #b01)      
  ((REF-SYS/SCALE-SYS) => #b10) 
  (R/M => #b11)) ; (ADD EBX EAX)

(define-value MOD-REG-R/M 
  (width 8) 
  (fields MOD REG R/M))

(define-value SIB 
  (width 8) 
  (fields SCALE INDEX BASE))

