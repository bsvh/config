;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Startup speedups                                                          ;; 
;; Stolen from: https://github.com/Bassmann/emacs-config/blob/master/init.el ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Speedup startup by reducing Garbage Collector
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)

;; Every file opened and loaded by Emacs will run through this list to check
;; for a proper handler for the file, but during startup, it won’t need any of
;; them.
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; After Emacs startup has been completed, set `gc-cons-threshold' to
;; 16 MB and reset `gc-cons-percentage' to its original value.
;; Also reset `file-name-handler-alist'
(add-hook 'emacs-startup-hook
          (lambda ()
             (setq gc-cons-threshold (* 16 1024 1024)
                   gc-cons-percentage 0.1
                   file-name-handler-alist file-name-handler-alist-original)
             (makunbound 'file-name-handler-alist-original)))

;; For startup profiling
(setq esup-depth 0)
(setq create-lockfiles nil)
;; Put backup files neatly away                                                 
(let ((backup-dir "~/.local/share/emacs/backups")
      (auto-saves-dir "~/.cache/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks                           
      delete-old-versions t  ; Clean up the backups                             
      version-control t      ; Use version numbers on backups,                  
      kept-new-versions 5    ; keep some new versions                           
      kept-old-versions 2)   ; and some old ones, too      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme, Disable GUI Elements                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-screen t)


;; Remove toolbar, menubar, scrollbar, and window decorations
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(set-frame-parameter nil 'undecorated t) ;; CUrrently doesn't  work in daemon mode

;; Fix titlebar for toolbox containers
(if (string= system-name "toolbox")
    (progn
      (with-temp-buffer
	(insert-file-contents "/run/.containerenv")
	(setq toolbox-name (when (string-match "name=\"\\(.*?\\)\"" (buffer-string))
			     (match-string 1 (buffer-string)))))
      (setq frame-title-format '("" "%b - GNU Emacs @ " toolbox-name ".toolbox"))))

;; Add header bar
(defun center-header-line (text)
  (let ((left-padding
	 (/ (- (window-total-width) (length (format-mode-line text))) 2)))
    (concat
     (format
      (format "%%%ds" left-padding) "")
     text)))
(defun short-filename-or-buffer ()
  (if (buffer-file-name)
      (abbreviate-file-name buffer-file-name)
    "%b"))
(add-hook 'buffer-list-update-hook
	  (lambda ()
	    (setq header-line-format
		  (center-header-line (short-filename-or-buffer)))))
(add-hook 'window-size-change-functions
	  (lambda (x)
	    (setq header-line-format
		  (center-header-line (short-filename-or-buffer)))))


(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 90))

;; Setup fonts
(set-face-attribute 'default nil :family "Hack FC Ligatured" :height 130)
(set-face-attribute 'fixed-pitch nil :family "Hack FC Ligatured" :height 1.0)
(set-face-attribute 'variable-pitch nil :family "Spectral" :height 1.0)
(set-face-attribute 'mode-line nil :family "Hack" :height 0.8)
(set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)

;; Set wrap to 80 chars
(setq-default fill-column 80)
(setq-default visual-fill-column-center-text t)
(add-hook 'text-mode-hook 'visual-line-mode)
(setq-default visual-fill-column-center-text t)
(add-hook 'visual-line-mode-hook #'visual-fill-column-mode)

;; Prevent GUI from zombieing out 
(global-unset-key (kbd "C-z"))

;; Overwrite selection when typing
(delete-selection-mode 1)

(setq-default line-spacing 0.1)
(setq-default electric-quote-replace-double t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup packages                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)

;; Force use of emacsPackages from nix
(setq package-archives nil)
(setq package-enable-at-startup nil)
(package-initialize)

(use-package hide-mode-line
  :init
  (add-hook 'markdown-mode-hook #'hide-mode-line-mode)
  :bind ("<f8>" . hide-mode-line-mode))

(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs t
	modus-themes-intense-mouseovers t
	modus-themes-paren-match '(bold intense)
	modus-themes-region '(bg-only no-extend accented))
  (modus-themes-load-themes)
  :config
  (modus-themes-load-operandi)
  ;; Change color of header-line box (used for padding) to background color
  (defun my-update-header-box ()
    (interactive)
    (modus-themes-load-themes)
    (if (eq (modus-themes--current-theme) 'modus-operandi)
	(face-remap-add-relative 'header-line nil '(:box (:line-width 12 :color "white")))
      (face-remap-add-relative 'header-line nil '(:box (:line-width 12 :color "black")))))
  (advice-add 'modus-themes-toggle :after #'my-update-header-box)
  :bind ("<f5>" . modus-themes-toggle))


(require 'org-protocol)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful For Editing Text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package expand-region
  :init
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package move-text
  :config
  (move-text-default-bindings))

(use-package writegood-mode)
(use-package writegood-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown Mode                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package markdown-mode
  :init
  (setq-default markdown-hide-markup t)
  (add-hook 'markdown-mode-hook
          (lambda ()
            (when buffer-file-name
              (add-hook 'after-save-hook
                        'check-parens
                        nil t))))
  (add-hook 'markdown-mode-hook #'electric-quote-local-mode) )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mixed pitch                                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  (text-mode . mixed-pitch-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode                                                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-bullets)
(use-package org-modern)
(use-package org
  :mode (("\\.org$" . org-mode))
  :config
  ;(add-hook 'auto-save-hook 'org-save-all-org-buffers)
  ;;(setq org-startup-indented f)
  (setq org-indent-indentation-per-level 1)
  (setq org-adapt-indentation nil)
  ;;(setq org-hide-leading-starts f)
  (setq org-hide-emphasis-markers t)
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-preview-latex-image-directory "~/.cache/org-latex-images/")
  (customize-set-variable 'org-blank-before-new-entry 
                          '((heading . nil)
                            (plain-list-item . nil)))
  (setq org-cycle-separator-lines 1)
  (setq org-log-done 'time)
  
  (setq org-agenda-files '("~/documents/org/inbox.org"
                         "~/documents/org/projects.org"
                         "~/documents/org/tickler.org"))
  (defun transform-square-brackets-to-round-ones(string-to-transform)
    "Transforms [ into ( and ] into ), other chars left unchanged."
    (concat 
     (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform))
  )
  (setq org-capture-templates '(
				("t" "Todo [inbox]" entry
				 (file+headline "~/documents/org/inbox.org" "Tasks")
				 "* TODO %i%?")
				("T" "Tickler" entry
                                 (file+headline "~/documents/org/tickler.org" "Tickler")
                                 "* TODO %^{Task} \n %^{Date}t \n %i" :time-prompt t)
			        ("s" "Songs" entry
			         (file+headline "~/documents/org/inbox.org" "Songs")
			         "* TODO Download %^{Song} by %^{Artist}%?")
				("p" "Protocol" entry
				 (file+headline  "~/documents/org/inbox.org" "Web")
				 "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
				("L" "Protocol Link" entry
				 (file+headline "~/documents/org/inbox.org" "Web")
				 "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]] \nCaptured On: %U")
				("b" "Add book to reading list" entry
				 (file+headline "~/documents/org/readinglist.org" "Reading List")
				 "* %^{Title} by %^{Author} \nAdded On: %u")
				("S" "Sell item on eBay" entry
				 (file+headline "~/documents/org/projects.org" "Sell on Ebay")
				 "* TODO %^{Item} [0\%] \n** TODO Research market value :RESEARCH: \n** TODO Determing shipping costs :RESEARCH: \n** TODO Photograph items \n** TODO Make listing \n** WAITING Sell item \n** WAITING Ship item")
				("a" "Add to Activity Log")
				("aw" "Walk" entry
				 (file+olp+datetree "~/documents/org/fitness.org" "Activity Log")
				 "* Walk - Steps: %^{Steps}, Distance: %^{Distance (m)}m, Time: %^{Time}\nNotes: %?")
				("ar" "Walk" entry
				 (file+olp+datetree "~/documents/org/fitness.org" "Activity Log")
				 "* Run - Distance: %^{Distance (m)}m, Time: %^{Time} \nNotes: %?")
				))
  (setq org-refile-targets '(("~/documents/org/projects.org" :maxlevel . 3)
                             ("~/documents/org/someday.org" :level . 1)
			     ("~/documents/org/readinglist.org" :maxlevel . 2)
                           ("~/documents/org/tickler.org" :maxlevel . 2)))
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  
  (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)
  
  (org-defkey org-mode-map (kbd "C-M-<return>") (lambda ()
						(interactive)
						(org-insert-heading-respect-content)
						(org-demote-subtree)))
  (org-defkey org-mode-map (kbd "M-i") (lambda ()
				        (interactive)
				        (tab-to-tab-stop)))
  (org-defkey org-mode-map (kbd "C-c i") #'org-insert-link)
  (org-defkey org-mode-map (kbd "C-c I") #'org-insert-last-stored-link))
  :init
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  '(require 'ox-epub nil t)
  '(require 'ox-publish)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python                                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python-black
  :demand t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rust                                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rustic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Variables                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Specify location for Customize so it doesn't try to write to R/O init.el
(setq custom-file "~/.config/emacs/emacs-custom.el")

(custom-set-variables
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(tool-bar-mode nil)
 '(warning-suppress-log-types '((comp)))
 '(warning-suppress-types '((emacs) (emacs) (comp))))
(custom-set-faces
 '(header-line ((t (:foreground "#7a7a7a" :background "inherit" :slant italic :box (:line-width 12 :color "white")))))
 '(markdown-header-face-1 ((t (:inherit default :foreground "#000000" :family "Albert Sans Light" :weight light :height 1.8))))
 '(markdown-header-face-2 ((t (:inherit default :foreground "#000000" :family "Albert Sans Light" :weight light :height 1.4))))
 '(markdown-header-face-3 ((t (:inherit default :foreground "#000000" :family "Spectral SC Extralight" :weight extra-light :height 1.0))))
 '(markdown-header-face-4 ((t (:inherit default :foreground "#000000" :family "Spectral SC" :weight normal :height 0.8))))
 '(markdown-header-face-5 ((t (:inherit default :foreground "#000000" :family "Spectral SC" :weight normal :height 0.8))))
 '(org-document-title ((t (:inherit default :foreground "#B71C1C" :underline "#aaaaaa" :height 1.0))))
 '(org-hide ((t (:inherit fixed-pitch :foreground "#e1d9c2"))))
 '(org-level-1 ((t (:inherit default :foreground "#770b0b" :family "Montserrat" :weight medium :height 1.6))))
 '(org-level-2 ((t (:inherit default :foreground "#770b0b" :family "Montserrat" :weight medium :height 1.4))))
 '(org-level-3 ((t (:inherit default :foreground "#770b0b" :family "Montserrat" :weight medium :height 1.2))))
 '(org-level-4 ((t (:inherit default :foreground "#770b0b" :family "Montserrat" :weight medium :height 1.0))))
 '(org-level-5 ((t (:inherit default :foreground "#770b0b" :family "Montserrat" :weight medium :height 0.9)))))
(define-advice org-indent-set-line-properties (:override (level indentation &optional heading) sensible-indentation)
  (let* ((line (aref (pcase heading
               (`nil org-indent--text-line-prefixes)
               (`inlinetask org-indent--inlinetask-line-prefixes)
               (_ org-indent--heading-line-prefixes))
             level)))
    ;; Add properties down to the next line to indent empty lines.
    (add-text-properties (line-beginning-position) (line-beginning-position 2)
             `(line-prefix ,line)))
  (forward-line))

(when (file-exists-p custom-file)
  (load custom-file))
