;; MELPA
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

;; Enable js2-mode on js file load
(require 'rjsx-mode)
(add-to-list 'auto-mode-alist (cons (rx ".js" eos) 'rjsx-mode))

;; vue mode
(require 'vue-mode)
(add-to-list 'auto-mode-alist (cons (rx ".vue" eos) 'vue-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist (cons (rx ".html" eos) 'web-mode))
(add-to-list 'auto-mode-alist (cons (rx ".css" eos) 'web-mode))

;; Ace Jump Mode
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; Add cmake listfile names to the mode list
(require 'cmake-mode)
(autoload 'cmake-mode "~/CMake/Auxiliary/cmake-mode.el" t)

;; Add dockerfile mode
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; Add protobuf mode
(require 'protobuf-mode)
(add-to-list 'auto-mode-alist '("*.proto\\'" . dockerfile-mode))

;; Slime
;; start slime automatically when we open a lisp file
(require 'slime)
(defun prelude-start-slime ()
  (unless (slime-connected-p)
    (save-excursion (slime))))
(add-hook 'slime-mode-hook 'prelude-start-slime)

;; Paredit
(require 'paredit)
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'slime-repl-mode-hook 'paredit-mode)

;; set sbcl
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(setq slime-contribs '(slime-fancy))

;; GDB hotkeys
(define-key global-map (kbd "C-x SPC") 'gud-break)

;; Org hotkeys
(define-key global-map [(control meta ?r)] 'org-capture)

;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
(defun prelude-override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))

(add-hook 'slime-repl-mode-hook 'prelude-override-slime-repl-bindings-with-paredit)

(eval-after-load "slime"
  '(progn
     (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol
           slime-fuzzy-completion-in-place t
           slime-enable-evaluate-in-emacs t
           slime-autodoc-use-multiline-p t)

     (define-key slime-mode-map (kbd "TAB") 'slime-indent-and-complete-symbol)
     (define-key slime-mode-map (kbd "C-c i") 'slime-inspect)
     (define-key slime-mode-map (kbd "C-c C-s") 'slime-selector)))

;; Neo tree
(require 'neotree)
(global-set-key (kbd "C-\\") 'neotree-toggle)

;; Spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default c-basic-offset 2)
(setq-default js2-basic-offset 2)

;; CMAKE
(add-to-list 'load-path "/usr/share/cmake-3.2/editors/emacs/")
(load "cmake-mode.el")
(require 'cmake-mode)

;; Auto-Complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)

(defun auto-complete-mode-maybe ()
  "No maybe for you. Only AC!"
  (unless (minibufferp (current-buffer))
    (auto-complete-mode 1)))

;; Semantic
(semantic-mode 1)
(defun my:add-semantic-to-autocomplete()
  (add-to-list 'ac-sources 'ac-source-semantic)
  )
(add-hook 'djkoelz-c-hook 'my:add-semantic-to-autocomplete)

;; iEdit
(defun iedit-dwim (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (narrow-to-defun)
          (iedit-start (current-word) (point-min) (point-max)))))))
(global-set-key (kbd "C-;") 'iedit-dwim)

;; Uncomment Region Global
(global-set-key (kbd "\C-c u") 'uncomment-region)

;; Comment Region Global 
;; NOTE : doing this because C-c C-c is necessary in lisp-mode
(global-set-key (kbd "\C-c c") 'comment-region)

;; Add Line Numbers
(global-linum-mode t)

;; Emacs to start up in full screen
(defun toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
												 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
												 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  )

(when (display-graphic-p) (toggle-fullscreen))

;; Enable AutoRevert Buffer Functionality
(global-auto-revert-mode 1)
(setq auto-revert-check-vc-info t)

;; Set backup file location
(setq backup-directory-alist '(("." . "~/.saves")))

;; Determine the underlying operating system
(setq djkoelz-aquamacs (featurep 'aquamacs))
(setq djkoelz-linux (featurep 'x))
(setq djkoelz-win32 (not (or djkoelz-aquamacs djkoelz-linux)))

;; (NOTE) djkoelz : Removed when you install Slime through MELPA
;; Set your lisp system and, optionally, some contribs
;; Set up the Common Lisp environment
;;(setq inferior-lisp-program "/usr/local/share/emacs/25.2/lisp")
;;(setq slime-backend "/usr/share/common-lisp/source/slime/swank-loader.lisp")
;;(add-to-list 'load-path "/usr/share/common-lisp/source/slime/")

(global-hl-line-mode 1)
(set-face-background 'hl-line "midnight blue")

(setq compilation-directory-locked nil)
(scroll-bar-mode -1)
(setq shift-select-mode nil)
(setq enable-local-variables nil)
(setq djkoelz-font "outline-DejaVu Sans Mono")

;; Removes the (Ctrl-Z) function
;;(global-unset-key (kbd "C-z"))

(when djkoelz-win32
  (setq djkoelz-makescript "build.bat")
  (setq djkoelz-font "outline-Liberation Mono")
  )

(when djkoelz-aquamacs 
  (cua-mode 0) 
  (osx-key-mode 0)
  (tabbar-mode 0)
  (setq mac-command-modifier 'meta)
  (setq x-select-enable-clipboard t)
  (setq aquamacs-save-options-on-quit 0)
  (setq special-display-regexps nil)
  (setq special-display-buffer-names nil)
  (define-key function-key-map [return] [13])
  (setq mac-command-key-is-meta t)
  (scroll-bar-mode nil)
  (setq mac-pass-command-to-system nil)
  (setq djkoelz-makescript "./build.macosx")
  )

(when djkoelz-linux
  (setq djkoelz-makescript "./.build.sh")
  (display-battery-mode 1)
  )

;; Turn off the toolbar
(tool-bar-mode 0)
(load-library "view")
(require 'cc-mode)
(require 'ido)
(require 'compile)
(ido-mode t)

;; Setup my find-files
(define-key global-map "\ef" 'find-file)
(define-key global-map "\eF" 'find-file-other-window)

(global-set-key (read-kbd-macro "\eb")  'ido-switch-buffer)
(global-set-key (read-kbd-macro "\eB")  'ido-switch-buffer-other-window)

(defun djkoelz-ediff-setup-windows (buffer-A buffer-B buffer-C control-buffer)
  (ediff-setup-windows-plain buffer-A buffer-B buffer-C control-buffer)
  )
(setq ediff-window-setup-function 'djkoelz-ediff-setup-windows)
(setq ediff-split-window-function 'split-window-horizontally)

;; Turn off the bell on Mac OS X
(defun nil-bell ())
(setq ring-bell-function 'nil-bell)

;; Setup my compilation mode
(defun djokelz-compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil)
  )

(add-hook 'compilation-mode-hook 'djokelz-compilation-hook)

(defun load-todo ()
  (interactive)
  (find-file djkoelz-todo-file)
  )
(define-key global-map "\et" 'load-todo)

(defun insert-timeofday ()
  (interactive "*")
  (insert (format-time-string "%a, %d %b %y: %I:%M%p")))

(defun insert-documentation ()
  (interactive "*")
  (insert "/**\n")
  (insert " * @name        $\n")
  (insert " * @brief       $\n")
  (insert " * @return      $\n")
  (insert " * @throws      $\n")
  (insert " */\n"))

;; no screwing with my middle mouse button
(global-unset-key [mouse-2])

;; Bright-red TODOs
(setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-note-face)
(mapc (lambda (mode)
				(font-lock-add-keywords
				 mode
				 '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
					 ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
      fixme-modes)
(modify-face 'font-lock-fixme-face "Red" nil nil t nil t nil nil)
(modify-face 'font-lock-note-face "Dark Green" nil nil t nil t nil nil)

;; Accepted file extensions and their appropriate modes
(setq auto-mode-alist
      (append
       '(("\\.cpp$"    . c++-mode)
         ("\\.hin$"    . c++-mode)
         ("\\.cu$"    . c++-mode)
         ("\\.cin$"    . c++-mode)
         ("\\.inl$"    . c++-mode)
				 ("\\.ino$"    . c++-mode)
         ("\\.rdc$"    . c++-mode)
         ("\\.h$"    . c++-mode)
         ("\\.c$"   . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.c8$"   . c++-mode)
				 ("\\.cmake$" . cmake-mode)
				 ("\\CMakeLists.txt$" . cmake-mode)
         ("\\.txt$" . indented-text-mode)
         ("\\.emacs$" . emacs-lisp-mode)
         ("\\.gen$" . gen-mode)
         ("\\.ms$" . fundamental-mode)
         ("\\.m$" . objc-mode)
         ("\\.mm$" . objc-mode)
         ("\\.launch$" . xml-mode)
         ) auto-mode-alist))

;; C++ indentation style
(defconst djkoelz-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-basic-offset              . 4)
    (c-comment-only-line-offset  . 0)
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  c-lineup-for)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
    (c-echo-syntactic-information-p . t))
  "Djkoelz's Big Fun C++ Style")


;; CC++ mode handling
(defun djkoelz-c-hook ()
  ;; Set my style for the current buffer
  (c-add-style "BigFun" djkoelz-c-style t)
  
  ;; 2-space tabs
  (setq tab-width 2 indent-tabs-mode nil)

  ;; Additional style stuff
  (c-set-offset 'member-init-intro '++)

  ;; No hungry backspace
  (c-toggle-auto-hungry-state -1)

  ;; Newline indents, semi-colon doesn't
  (define-key c++-mode-map "\C-m" 'newline-and-indent)
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

  ;; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t)

  ;; Abbrevation expansion
  (abbrev-mode 1)
  
  (defun djkoelz-header-format ()
    "Format the given file as a header file."
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    (insert "#ifndef ")
    (push-mark)
    (insert BaseFileName)
    (upcase-region (mark) (point))
    (pop-mark)
    (insert "_H\n")
    (insert "/******************************************************************************** \n")
    (insert " * Copyright (C) 2000-2016 Caterpillar Inc. All Rights Reserved.\n")
    (insert " * \n")
    (insert " * @project: \n")
    (insert " * @file:    \n")
    (insert " * @author:  Derrill Koelz \n")
    (insert " * @created: \n")
    (insert " * @updated: \n")
    (insert " * \n")
    (insert " * @brief \n")
    (insert " ******************************************************************************** \n")
    (insert "*/\n")
    (insert "#define ")
    (push-mark)
    (insert BaseFileName)
    (upcase-region (mark) (point))
    (pop-mark)
    (insert "_H\n")
    (insert "#endif")
    )

  (defun djkoelz-source-format ()
    "Format the given file as a source file."
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    (insert "/******************************************************************************** \n")
    (insert " * Copyright (C) 2000-2016 Caterpillar Inc. All Rights Reserved.\n")
    (insert " * \n")
    (insert " * @project: \n")
    (insert " * @file:    \n")
    (insert " * @author:  Derrill Koelz \n")
    (insert " * @created: \n")
    (insert " * @updated: \n")
    (insert " * \n")
    (insert " * @brief \n")
    (insert " ******************************************************************************** \n")
    (insert "*/\n")
    )

  (cond ((file-exists-p buffer-file-name) t)
        ((string-match "[.]hin" buffer-file-name) (djkoelz-source-format))
        ((string-match "[.]cin" buffer-file-name) (djkoelz-source-format))
        ((string-match "[.]h" buffer-file-name) (djkoelz-header-format))
        ((string-match "[.]cpp" buffer-file-name) (djkoelz-source-format)))

  (defun djkoelz-find-corresponding-file ()
    "Find the file that corresponds to this one."
    (interactive)
    (setq CorrespondingFileName nil)
    (setq BaseFileName (file-name-sans-extension buffer-file-name))
    (if (string-match "\\.c" buffer-file-name)
				(setq CorrespondingFileName (concat BaseFileName ".h")))
    (if (string-match "\\.h" buffer-file-name)
				(if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
					(setq CorrespondingFileName (concat BaseFileName ".cpp"))))
    (if (string-match "\\.hin" buffer-file-name)
				(setq CorrespondingFileName (concat BaseFileName ".cin")))
    (if (string-match "\\.cin" buffer-file-name)
				(setq CorrespondingFileName (concat BaseFileName ".hin")))
    (if (string-match "\\.cpp" buffer-file-name)
				(setq CorrespondingFileName (concat BaseFileName ".hpp")))
    (if CorrespondingFileName (find-file CorrespondingFileName)
      (error "Unable to find a corresponding file")))
  (defun djkoelz-find-corresponding-file-other-window ()
    "Find the file that corresponds to this one."
    (interactive)
    (find-file-other-window buffer-file-name)
    (djkoelz-find-corresponding-file)
    (other-window -1))
  (define-key c++-mode-map [f12] 'djkoelz-find-corresponding-file)
  (define-key c++-mode-map [M-f12] 'djkoelz-find-corresponding-file-other-window)

  ;; Alternate bindings for F-keyless setups (ie MacOS X terminal)
  (define-key c++-mode-map "\ec" 'djkoelz-find-corresponding-file)
  (define-key c++-mode-map "\eC" 'djkoelz-find-corresponding-file-other-window)

  (define-key c++-mode-map "\es" 'djkoelz-save-buffer)

  (define-key c++-mode-map [C-tab] 'indent-region)
  (define-key c++-mode-map "	" 'indent-region)

  (define-key c++-mode-map "\ez" 'kill-region)

  ;; devenv.com error parsing
  (add-to-list 'compilation-error-regexp-alist 'djkoelz-devenv)
  (add-to-list 'compilation-error-regexp-alist-alist '(djkoelz-devenv
																											 "*\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:see declaration\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
																											 2 3 nil (4)))
  )

(defun djkoelz-replace-string (FromString ToString)
  "Replace a string without moving point."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion
    (replace-string FromString ToString)
    ))
(define-key global-map [f8] 'djkoelz-replace-string)

(add-hook 'c-mode-common-hook 'djkoelz-c-hook)

(defun djkoelz-save-buffer ()
  "Save the buffer after untabifying it."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (untabify (point-min) (point-max))))
  (save-buffer))

;; TXT mode handling
(defun djkoelz-big-fun-text-hook ()
  ;; 2-space tabs
  ;; (setq tab-width 2
  ;;       indent-tabs-mode nil)
  
  ;; Newline indents, semi-colon doesn't
  ;;(define-key text-mode-map "\C-m" 'newline-and-indent)

  ;; Prevent overriding of alt-s
  (define-key text-mode-map "\es" 'djkoelz-save-buffer)
  )
(add-hook 'text-mode-hook 'djkoelz-big-fun-text-hook)

;; Navigation
(defun previous-blank-line ()
  "Moves to the previous line containing nothing but whitespace."
  (interactive)
  (search-backward-regexp "^[ \t]*\n")
  )

(defun next-blank-line ()
  "Moves to the next line containing nothing but whitespace."
  (interactive)
  (forward-line)
  (search-forward-regexp "^[ \t]*\n")
  (forward-line -1)
  )

(define-key global-map (kbd "C-S-f") 'forward-word)
(define-key global-map (kbd "C-S-b") 'backward-word)
(define-key global-map [C-up] 'previous-blank-line)
(define-key global-map [C-down] 'next-blank-line)
(define-key global-map [home] 'beginning-of-line)
(define-key global-map [end] 'end-of-line)
(define-key global-map [pgup] 'forward-page)
(define-key global-map [pgdown] 'backward-page)
(define-key global-map [C-next] 'scroll-other-window)
(define-key global-map [C-prior] 'scroll-other-window-down)

;; ALT-alternatives
(defadvice set-mark-command (after no-bloody-t-m-m activate)
  "Prevent consecutive marks activating bloody `transient-mark-mode'."
  (if transient-mark-mode (setq transient-mark-mode nil)))

(defadvice mouse-set-region-1 (after no-bloody-t-m-m activate)
  "Prevent mouse commands activating bloody `transient-mark-mode'."
  (if transient-mark-mode (setq transient-mark-mode nil))) 

(define-key global-map "\ez" 'kill-region)
(define-key global-map [M-up] 'previous-blank-line)
(define-key global-map [M-down] 'next-blank-line)
(define-key global-map [M-right] 'forward-word)
(define-key global-map [M-left] 'backward-word)

(define-key global-map [f9] 'first-error)
(define-key global-map [f10] 'previous-error)
;;(define-key global-map [f11] 'next-error)
(define-key global-map "\eg" 'goto-line)

;; Editting
(define-key global-map "" 'copy-region-as-kill)
(define-key global-map "" 'yank)
(define-key global-map "\eu" 'undo)
(define-key global-map "\e6" 'upcase-word)
(define-key global-map "\e." 'fill-paragraph)

(defun djkoelz-replace-in-region (old-word new-word)
  "Perform a replace-string in the current region."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion (save-restriction
										(narrow-to-region (mark) (point))
										(beginning-of-buffer)
										(replace-string old-word new-word)
										))
  )
(define-key global-map "\el" 'djkoelz-replace-in-region)

(define-key global-map "\eo" 'query-replace)
(define-key global-map "\eO" 'djkoelz-replace-string)

;; \377 is alt-backspace
(define-key global-map "\377" 'backward-kill-word)
(define-key global-map [M-delete] 'kill-word)

;; Buffers
(define-key global-map "\er" 'revert-buffer)
(define-key global-map "\ek" 'kill-this-buffer)
(define-key global-map "\es" 'save-buffer)

;; Compilation
(setq compilation-context-lines 0)
(setq compilation-error-regexp-alist
      (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
						compilation-error-regexp-alist))

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p djkoelz-makescript) t
    (cd "../")
    (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (switch-to-buffer-other-window "*compilation*")
  ;; Using the below to open compilation in new frame
  ;; (switch-to-buffer-other-frame "*compilation*")
  (if compilation-directory-locked (cd last-compilation-directory)
    (cd find-project-from-directory)
    (find-project-directory-recursive)
    (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (if (find-project-directory) (compile djkoelz-makescript))
  (other-window 1))
(define-key global-map "\em" 'make-without-asking)

;; Commands
(set-variable 'grep-command "grep -irHn ")
(when djkoelz-win32
  (set-variable 'grep-command "findstr -s -n -i -l "))

;; Smooth scroll
(setq scroll-step 3)

;; Clock
(display-time)

;; Startup windowing
(setq next-line-add-newlines nil)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(auto-save-interval 0)
 '(auto-save-list-file-prefix nil)
 '(auto-save-timeout 0)
 '(auto-show-mode t t)
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-safe-themes
   (quote
    ("ec5f697561eaf87b1d3b087dd28e61a2fc9860e4c862ea8e6b0b77bd4967d0ba" default)))
 '(delete-auto-save-files nil)
 '(delete-old-versions (quote other))
 '(fci-rule-color "#383838")
 '(imenu-auto-rescan t)
 '(imenu-auto-rescan-maxout 500000)
 '(inhibit-startup-screen t)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(make-backup-file-name-function (quote ignore))
 '(make-backup-files nil)
 '(mouse-wheel-follow-mouse nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (15)))
 '(neo-window-width 45)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-agenda-custom-commands
   (quote
    (("d" todo "DELEGATED" nil)
     ("c" todo "DONE|DEFERRED|CANCELLED" nil)
     ("w" todo "WAITING" nil)
     ("W" agenda ""
      ((org-agenda-ndays 21)))
     ("A" agenda ""
      ((org-agenda-skip-function
        (lambda nil
          (org-agenda-skip-entry-if
           (quote notregexp)
           "\\=.*\\[#A\\]")))
       (org-agenda-ndays 1)
       (org-agenda-overriding-header "Today's Priority #A tasks: ")))
     ("u" alltodo ""
      ((org-agenda-skip-function
        (lambda nil
          (org-agenda-skip-entry-if
           (quote scheduled)
           (quote deadline)
           (quote regexp)
           "
]+>")))
       (org-agenda-overriding-header "Unscheduled TODO entries: "))))))
 '(org-agenda-files (quote ("~/todo.org")))
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file+headline "~/todo.org" "Tasks")
      "* TODO %?
  %u")
     ("j" "Journal" entry
      (file+headline "~/journal.org" "Journal Entries")
      "* NOTE %u
  %?")
     ("m" "Meeting" entry
      (file+headline "~/meeting-notes.org" "Meeting Notes")
      "* NOTE %u
  %?"))))
 '(org-deadline-warning-days 14)
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-remember-store-without-prompt t)
 '(org-reverse-note-order t)
 '(package-selected-packages
   (quote
    (vue-mode protobuf-mode paredit ac-slime slime go-mode zenburn-theme web-mode rjsx-mode neotree dockerfile-mode cmake-mode auto-complete ace-jump-mode)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(standard-indent 2)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(version-control nil)
 '(web-mode-auto-close-style 2))

(define-key global-map [C-tab] 'indent-region)
(define-key global-map "	" 'indent-region)

(defun djkoelz-never-split-a-window
    "Never, ever split a window.  Why would anyone EVER want you to do that??"
  nil)
(setq split-window-preferred-function 'djkoelz-never-split-a-window)

(add-to-list 'default-frame-alist '(font . "Liberation Mono-10.5"))
(set-face-attribute 'default t :font "Liberation Mono-10.5")

(defun post-load-stuff ()
  (interactive)
  (menu-bar-mode -1)
  (set-background-color "#1c1c1c")
  )

(defun run-after-make-frame-functions (frame)
  (with-selected-frame frame
    (set-background-color "#1c1c1c")))

(add-hook 'window-setup-hook 'post-load-stuff t)
(add-hook 'after-make-frame-functions 'run-after-make-frame-functions)

;; Theme
(load-theme 'zenburn t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ace-jump-face-background ((t (:background "#3F3F3F" :foreground "gray40" :inverse-video nil))))
 '(ace-jump-face-foreground ((t (:background "#3F3F3F" :foreground "red" :inverse-video nil :underline nil))))
 '(term-color-black ((t (:foreground "#3F3F3F" :background "#2B2B2B"))))
 '(term-color-blue ((t (:foreground "#7CB8BB" :background "#4C7073"))))
 '(term-color-cyan ((t (:foreground "#93E0E3" :background "#8CD0D3"))))
 '(term-color-green ((t (:foreground "#7F9F7F" :background "#9FC59F"))))
 '(term-color-magenta ((t (:foreground "#DC8CC3" :background "#CC9393"))))
 '(term-color-red ((t (:foreground "#AC7373" :background "#8C5353"))))
 '(term-color-white ((t (:foreground "#DCDCCC" :background "#656555"))))
 '(term-color-yellow ((t (:foreground "#DFAF8F" :background "#9FC59F"))))
 '(term-default-bg-color ((t (:inherit term-color-black))))
 '(term-default-fg-color ((t (:inherit term-color-white)))))

(require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(define-key mode-specific-map [?a] 'org-agenda)

(eval-after-load "org"
  '(progn
     (define-prefix-command 'org-todo-state-map)

     (define-key org-mode-map "\C-cx" 'org-todo-state-map)

     (define-key org-todo-state-map "x"
       #'(lambda nil (interactive) (org-todo "CANCELLED")))
     (define-key org-todo-state-map "d"
       #'(lambda nil (interactive) (org-todo "DONE")))
     (define-key org-todo-state-map "f"
       #'(lambda nil (interactive) (org-todo "DEFERRED")))
     (define-key org-todo-state-map "l"
       #'(lambda nil (interactive) (org-todo "DELEGATED")))
     (define-key org-todo-state-map "s"
       #'(lambda nil (interactive) (org-todo "STARTED")))
     (define-key org-todo-state-map "w"
       #'(lambda nil (interactive) (org-todo "WAITING")))))

(require 'remember)

(add-hook 'remember-mode-hook 'org-remember-apply-template)

(define-key global-map [(control meta ?r)] 'org-capture)

;; golang stuff
(add-hook 'before-save-hook 'gofmt-before-save)
(defun my-go-mode-hook ()
  ;; Call Gofmt before saving                                                    
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ;; 2-space tabs
  (setq tab-width 4)
  (setq indent-tabs-mode 1)
  ;; Godef jump key binding
  (global-set-key (kbd "\C-c \C-c") 'comment-region)
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark))

(add-hook 'go-mode-hook 'my-go-mode-hook)

;; Custom capture mode stuff
(require 'org-capture)
(defun my-capture-finalize ()
  (interactive)
  (org-capture-finalize)
  (delete-other-frames))

(defun my-agenda-finalize ()
  (interactive)
  (delete-other-frames))

;; set org capture mode to close frame after closing
(add-hook 'org-capture-mode-hook
          (lambda () (define-key org-capture-mode-map "\C-c\C-c" (function my-capture-finalize))))

;; set agenda to open in current window
(setq org-agenda-window-setup 'current-window)

;; Close org agenda frame after opening
(add-hook 'org-agenda-mode-hook 'my-agenda-finalize)
