;;; assiah-mode.el --- Assiah editing mode

;; New code written by Joseph Osako <josephosako@gmail.com>
;; beginning 2015-01-05.
;; Copyright (C) 2015 Project Kether under the GNU Limited General
;; Public License.
;;; assiah-mode.el --- Assiah editing mode

;; New code written by Joseph Osako <josephosako@gmail.com>
;; beginning 2015-01-05.
;; Copyright (C) 2015 Project Kether under the GNU Limited General
;; Public License.

;; Kether and the Thelemic toolchain are free software; you may
;; redistribute and/or modify it under the terms of the GNU Limited
;; General Public License as published by Project Kether, either  
;; version 3 of the License, or (at your option) any later version. 

;; The Thelemic toolchain is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Limited General Public License for more details


;; Create mode-specific table variables.
(defvar assiah-mode-abbrev-table nil)
(define-abbrev-table 'assiah-mode-abbrev-table ())

(defvar assiah-mode-syntax-table
  (let ((st (make-syntax-table)))
    (modify-syntax_entry ?? "_" st)
    (modify-syntax_entry ?~ "_" st)
    (modify-syntax_entry ?! "_" st)
    (modify-syntax_entry ?$ "_" st)
    (modify-syntax_entry ?% "_" st)
    (modify-syntax_entry ?^ "_" st)
    (modify-syntax_entry ?& "_" st)
    (modify-syntax_entry ?* "_" st)
    (modify-syntax_entry ?_ "_" st)
    (modify-syntax_entry ?- "_" st)
    (modify-syntax_entry ?+ "_" st)
    (modify-syntax_entry ?= "_" st)
    (modify-syntax_entry ?| "_" st)
    (modify-syntax_entry ?\/ "_" st)
    ;; comment classes 
    (modify-syntax-entry ?\; "<" st)
    (modify-syntax-entry ?\n ">" st)
    (modify-syntax-entry ?# "' 14b" st)
    (modify-syntax-entry ?| "\" 23b" st) 
    st)
  "Syntax table used in `assiah-mode'.")

(defvar assiah-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\t" 'assiah-indent-sexp)
    (define-key map "\177" 'backward-delete-char-untabify)
    map)
  "Base Assiah mode keymap.")


(defconst regexp-prologue "\\(\\<\\|(\\)")

(defconst regexp-epilogue "\\>")

(defconst assiah-define-keywords 
  (concat regexp-prologue
	  (regexp-opt '("def-value" "def-proc" "def-struct" "def-syntax" 
			"def-char" "def-uchar"
			"def-string" "def-dstring" "def-zstring" "def-ustring"
			"def-udstring" "def-byte" "def-half-word" "def-word"
			"def-double-word" "def-quad-word" "def-oct-word"
			"def-bits" "def-origin"))
	  regexp-epilogue)) 

(defconst assiah-reserve-keywords 
  (concat regexp-prologue
	  (regexp-opt '("reserve-char" "reserve-uchar"
			"reserve-string" "reserve-dstring" "reserve-zstring" 
			"reserve-ustring" "reserve-udstring"
			"reserve-byte" "reserve-half-word" "reserve-word" 
			"reserve-double-word" "reserve-quad-word" 
			"reserve-oct-word"))
	  regexp-epilogue))

(defconst assiah-directive-keywords 
  (concat regexp-prologue
	  (regexp-opt '("section"))
	  regexp-epilogue))

(defconst assiah-directive-options
  (concat "\\<"
	  (regexp-opt '("code" "data" "stack" "read-only-data"
			"reserved-data-space" "declarations"))
	  regexp-epilogue))

(defconst assiah-program-header
  (concat regexp-prologue "def-program" regexp-epilogue))


(defconst assiah-comment-syntax "\\(;\\|#|\\||#\\)")

(defvar assiah-font-lock-keywords
  (list 
   '(assiah-define-keywords . font-lock-builtin-face)
   '(assiah-reserve-keywords . font-lock-data-face)
   '(assiah-directive-keywords . font-lock-keyword-face)
   '(assiah-directive-options . font-lock-data-face)
   '(assiah-comment-syntax . font-lock-comment-delimiter-face))
  "Font modes for Assiah")

;; labels begin with a colon and must be alone on their line
(defconst assiah-label "\\<\\(:\\s_+\\)\\>")


(defun assiah-indent-sexp ()
  (interactive)
  (beginning-of-line)
  (save-excursion
    (cond ((or
	    (looking-at "^\\s-*\\(;\\)")
	    (looking-at "^\\s-*\\(#|\\)"))
	   (message "comment start")
	   (indent-line-to (current-indentation)))
	  ((looking-at "^\\s-*\\(|#\\)")
	   (message "comment end")
	   (forward-line -1)
	   (if (not (looking-at "^\\s-*\\(#|\\)"))
	       (let ((new-indent (max 0 (- (current-indentation) 3))))
		 (forward-line 1)
		 (indent-line-to new-indent))
	     (let ((new-indent (current-identation)))
	       (forward-line 1)
	       (indent-line-to new-indentation))))
	  ((nth 4 (syntax-ppss))
	   (forward-line -1)
	   (if (looking-at "^\\s-*\\(#|\\)" )
	       (let ((new-indent (+ (current-indentation) 3)))
		 (forward-line 1)
		 (message "comment body")
		 (indent-line-to new-indent))
	     (let ((new-indent (current-indentation)))
	       (forward-line 1)
	       (indent-line-to new-indent))))
	  ;; the remaining indentations are all fixed, 
	  ;; with the spacing dependent on the type of expression
	  (t (indent-line-to 0)
	     (cond ((looking-at assiah-program-header)
		    (message "Program header")
		    (indent-line-to 0))
		   ((looking-at assiah-directive-keywords)
		    (message "assembler directive")
		    (indent-line-to 2))
		   ((or (looking-at assiah-reserve-keywords)
			(looking-at assiah-define-keywords))
		    (message "definition")
		    (indent-line-to 4))
		   ((looking-at assiah-label)
		    (message "label")
		    (indent-line-to 6))
		   (t 
		    (message "instruction")
		    ;; instructions always indent 8 chars
		    (indent-line-to 8))))))  
  (end-of-line))

(define-derived-mode assiah-mode prog-mode "Assiah" 
  "General major mode for the Assiah assembler
   \\{assiah-mode-map}"
  :syntax-table assiah-mode-syntax-table
  (setq case-fold-search nil)
  (set (make-local-variable 'indent-line-function) 'assiah-indent-sexp)
  (set (make-local-variable 'font-lock-defaults) '(assiah-font-lock-keywords)))

(provide 'assiah-mode)
