; YOU WILL WANT TO CHANGE THE LAST LINE OF THIS FILE (use an editor other than emacs).
; it should point to the folder where you want to store your Scheme code files.
; Don't forget to use forward slashes (as that line is now) instead of
; the standard Windows backslashes in your pathname.

; In MS Windows:

   ; After changing that, make a folder called .emacs.d in your 
   ; C:\Users\yourname\AppData\Roaming folder, and put this file there.

   ; You may need to check "Show hidden files" in your Windows Explorer View settings
   ; in order to see the AppData folder.  To change this settings in Windows7, press and release Alt
   ; to show the menus.  Choose Tools-->Folder Options, then the View tab.

   ;   While you are there, I recommend that you also uncheck "Hide extensions for known file types".
   ;   This is two items below "Show Hidden files" in the list.





;(autoload 'scheme-mode "iuscheme" "Major mode for Scheme." t)
;(autoload 'run-scheme "iuscheme" "Switch to interactive Scheme buffer." t)
(setq auto-mode-alist (cons '("\\.ss" . scheme-mode) auto-mode-alist))

;; Map home and end to go to the beginning and end of line, 
;;   shift-home to beginning of file
;; (pc-bindings-mode)

;; use shift-cursor to select text, typing will replace selected region.
;(pc-selection-mode)

(setq default-major-mode 'text-mode)

(global-set-key "%" 'run-scheme) 
(global-set-key "!" 'shell)

(setq scheme-program-name "petite")

(add-hook 'text-mode-hook 
  (function
   (lambda ()
     (auto-fill-mode 1)
     (local-set-key "
" 'newline-and-indent))))

(add-hook 'fundamental-mode-hook
  (function
   (lambda ()
     (local-set-key "
" 'newline-and-indent))))

(add-hook 'cc-mode-hook
  (function
   (lambda ()
     (local-set-key "
" 'newline-and-indent))))

(add-hook 'c++-mode-hook
  (function
   (lambda ()
     (local-set-key "
" 'newline-and-indent))))

(add-hook 'java-mode-hook
  (function
   (lambda ()
     (local-set-key "" 'newline-and-indent))))

(add-hook 'inferior-scheme-mode-hook
  (function
   (lambda ()
     (local-set-key "p" 'comint-previous-matching-input-from-input)
     (local-set-key "n" 'comint-next-matching-input-from-input))))
(add-hook 'shell-mode-hook
  (function
   (lambda ()
     (local-set-key "p" 'comint-previous-matching-input-from-input)
     (local-set-key "n" 'comint-next-matching-input-from-input))))
(add-hook 'scheme-mode-hook 
  (function
   (lambda ()
     (local-set-key "
" 'newline-and-indent))))
(add-hook 'java-mode-hook 
  (function
   (lambda ()
     (local-set-key "
" 'newline-and-indent))))

(setq inhibit-startup-message 't)


(put 'eval-when     'scheme-indent-function 1)
(put 'set!          'scheme-indent-function 1)
(put 'when          'scheme-indent-function 1)
(put 'unless        'scheme-indent-function 1)
(put 'record-case   'scheme-indent-function 1)
(put 'c-record-case 'scheme-indent-function 1)
(put 'variant-case  'scheme-indent-function 1)
(put 'parameterize  'scheme-indent-function 1)
(put 'call-with-values 'scheme-indent-function 1)
(put 'extend-syntax 'scheme-indent-function 1)
(put 'with          'scheme-indent-function 1)
(put 'let        'scheme-indent-function 1)
(put 'let-syntax    'scheme-indent-function 1)
(put 'letrec-syntax 'scheme-indent-function 1)
(put 'with-syntax   'scheme-indent-function 1)
(put 'syntax-case   'scheme-indent-function 2)
(put 'syntax  'scheme-indent-function 1)
(put 'syntax-rules  'scheme-indent-function 1)
(put 'foreign-procedure 'scheme-indent-function 1)
(put 'set-top-level-value! 'scheme-indent-function 1)
(put 'make-parameter 'scheme-indent-function 1)
(put 'decompose     'scheme-indent-function 2)
(put 'mvlet         'scheme-indent-function 1)
(put 'mvlet*        'scheme-indent-function 1)
(put 'state-case    'scheme-indent-function 1)
(put 'foreach       'scheme-indent-function 1)
(put 'vector-foreach 'scheme-indent-function 1)
(put 'assert        'scheme-indent-function 1)
(put 'fold-list     'scheme-indent-function 2)
(put 'fold-vector   'scheme-indent-function 2)
(put 'fold-count    'scheme-indent-function 2)
(put 'on-error      'scheme-indent-function 1)


(show-paren-mode 1)
(setq blink-matching-paren-distance nil)


(setq font-lock-face-attributes
      ;; Symbol-for-Face Foreground Background Bold Italic Underline
      '((font-lock-comment-face       "red" "lightsteelblue" t t nil )
	(font-lock-string-face        "firebrick"      )
	(font-lock-keyword-face       "orchid" )
	(Font-Lock-type-face          "olivedrab" )
	(font-lock-reference-face     "darkgreen"     )
	(font-lock-function-name-face "darkmagenta")
	(font-lock-variable-name-face "maroon4" )
	))

(require 'font-lock)
(setq font-lock-maximum-decoration 't)
(global-font-lock-mode t)
(setq font-lock-global-modes '(c-mode c++-mode emacs-lisp-mode scheme-mode))
(setq font-lock-use-colors t)
(setq font-lock-use-default-maximal-decoration t)





(fset 'send-to-scheme
   [?\C-  escape ?\C-f escape ?w ?\C-x ?o ?\C-y return ?\C-x ?o ?\C-e right])

(global-set-key "%" 'run-scheme)
(global-set-key "x" 'send-to-scheme)

(fset 'filename-to-href
   [?\C-  ?\C-e escape ?w ?\C-a ?< ?a ?  ?h ?r ?e ?f ?= ?\C-e ?> ?\C-y ?< ?/ ?a ?> ?< ?b ?r ?  ?/ ?> right])

(global-set-key "h" 'filename-to-href)

(fset 'index-to-images
   [?\C-  ?\C-s ?b ?r ?  ?/ ?> ?\C-e escape ?w ?\C-x ?o ?\C-r ?< ?p ?> right ?\C-s ?< ?/ ?p ?> ?\C-e right ?\C-y ?\C-r ?< ?a right ?\C-a right ?\C-d ?p ?> ?  ?< ?i ?m ?g ?\C-  ?\C-s ?= right left backspace backspace backspace backspace backspace ?s ?r ?c ?= ?\C-s ?> right left ?< ?b ?r ?  ?/ ?> ?\C-s ?b ?r ?  ?/ ?> left right backspace backspace backspace backspace backspace backspace backspace backspace ?i ?m ?g ?> ?< ?/ ?p ?>])

(global-set-key "i" 'index-to-images)



(fset 'student-pictures
   [?< ?t ?r ?> ?< ?t ?d ?> ?< ?i ?m ?g ?  ?s ?r ?c ?= ?" ?\C-y escape ?f ?" ?< ?/ ?t ?d ?< backspace ?> ?< ?t ?d ?> ?\C-e ?< ?/ ?t ?d ?> ?< ?t ?r backspace backspace ?/ ?t ?r ?> right])

(cd "c:/SVN/304/Scheme-source")