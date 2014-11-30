Assiah
======

A Lisp-flavored Assembler for the x86, x86-64, ARM, and MIPS ISAs

Assiah is a part of the Thelema Project toolchain, and intended both as
a standalone assembler and as a target for the Thelema complier. It
is intended to be a table-driven, retargetable assembler that is easy to
maintain and update.

However, what really will make Assiah unique will be its macro system. By
using an s-expression based syntax, Assiah will be amenable to supporting
a system of lexical macros, as opposed to the texual macros that are 
typical of other assemblers. Lexical macros are far more powerful than 
textual macros, as they can be composed to form more elaborate macro
structures, forming in effect a combination of an assembly language, on
the one hand, and a high level language on the other. 

Assiah macros will specifically follow the pattern of the hygienic macros
found in the later revisions of the Scheme programming language, a Lisp
dialect known for its simplicity and elegance. These hygienic macros
avoid many of the issues found in other lexical macros systems, most notably
variable capture. While the are more complex and slightly less powerful than
classic Lisp style macros, the added safety of hygienic macros makes them
ideal for working in the otherwise difficult environment of assembly code.
