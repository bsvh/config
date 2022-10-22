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
(set-frame-parameter nil 'undecorated t)

;; Fix titlebar for toolbox containers
(if (string= system-name "toolbox")
    (progn
      (with-temp-buffer
	(insert-file-contents "/run/.containerenv")
	(setq toolbox-name (when (string-match "name=\"\\(.*?\\)\"" (buffer-string))
			     (match-string 1 (buffer-string)))))
      (setq frame-title-format '("" "%b - GNU Emacs @ " toolbox-name ".toolbox"))))


(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 90))

;; Setup fonts
(set-face-attribute 'default nil :family "Hack FC Ligatured" :height 120)
(set-face-attribute 'fixed-pitch nil :family "Hack FC Ligatured" :height 1.0)
(set-face-attribute 'variable-pitch nil :family "Montserrat" :height 1.0)
(set-face-attribute 'mode-line nil :family "Hack" :height 0.8)
(set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'prepend)

;; Set wrap to 80 chars
(setq-default fill-column 80)
;;(setq-default visual-fill-column-center-text t)
(add-hook 'text-mode-hook 'visual-line-mode)
;;(setq-default visual-fill-column-center-text t)
(add-hook 'visual-line-mode-hook #'visual-fill-column-mode)

;; Prevent GUI from zombieing out 
(global-unset-key (kbd "C-z"))

;; Overwrite selection when typing
(delete-selection-mode 1)

(setq-default line-spacing 0.1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup packages                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Keep a list of packages and install them if needed
(setq package-list
      '(eglot
       esup 
       expand-region
       ;markdown-mode
       mixed-pitch
       modus-themes
       move-text
       org-bullets
       org-modern
       ox-epub
       ox-hugo
       poet-theme
       pdf-tools
       python-black
       pyvenv
       rustic
       treemacs
       treemacs-all-the-icons
       treemacs-icons-dired 
       use-package
       writegood-mode
       writeroom-mode))
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(eval-when-compile
  (require 'use-package))

(use-package modus-themes
  :ensure
  :init
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs t
	modus-themes-intense-mouseovers t
	modus-themes-paren-match '(bold intense)
	modus-themes-region '(bg-only no-extend accented))
  (modus-themes-load-themes)
  :config
  (modus-themes-load-operandi)
  :bind ("<f5>" . modus-themes-toggle))


(require 'org-protocol)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compile                                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package compile
  :config
  (global-set-key [f5] (lambda ()
                       (interactive)
                       (let ((current-prefix-arg '(4)))
                         (call-interactively 'compile)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Useful For Editing Text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package expand-region
  :init
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package move-text
  :config
  (move-text-default-bindings))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown Mode                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package markdown-mode
  :init
  (add-hook 'markdown-mode-hook
          (lambda ()
            (when buffer-file-name
              (add-hook 'after-save-hook
                        'check-parens
                        nil t)))))


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
  
  (setq org-agenda-files '("~/Documents/Org/inbox.org"
                         "~/Documents/Org/projects.org"
                         "~/Documents/Org/tickler.org"))
  (defun transform-square-brackets-to-round-ones(string-to-transform)
    "Transforms [ into ( and ] into ), other chars left unchanged."
    (concat 
     (mapcar #'(lambda (c) (if (equal c ?\[) ?\( (if (equal c ?\]) ?\) c))) string-to-transform))
  )
  (setq org-capture-templates '(
				("t" "Todo [inbox]" entry
				 (file+headline "~/Documents/Org/inbox.org" "Tasks")
				 "* TODO %i%?")
				("T" "Tickler" entry
                                 (file+headline "~/Documents/Org/tickler.org" "Tickler")
                                 "* TODO %^{Task} \n %^{Date}t \n %i" :time-prompt t)
			        ("s" "Songs" entry
			         (file+headline "~/Documents/Org/inbox.org" "Songs")
			         "* TODO Download %^{Song} by %^{Artist}%?")
				("p" "Protocol" entry
				 (file+headline  "~/Documents/Org/inbox.org" "Web")
				 "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
				("L" "Protocol Link" entry
				 (file+headline "~/Documents/Org/inbox.org" "Web")
				 "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]] \nCaptured On: %U")
				("b" "Add book to reading list" entry
				 (file+headline "~/Documents/Org/readinglist.org" "Reading List")
				 "* %^{Title} by %^{Author} \nAdded On: %u")
				("S" "Sell item on eBay" entry
				 (file+headline "~/Documents/Org/projects.org" "Sell on Ebay")
				 "* TODO %^{Item} [0\%] \n** TODO Research market value :RESEARCH: \n** TODO Determing shipping costs :RESEARCH: \n** TODO Photograph items \n** TODO Make listing \n** WAITING Sell item \n** WAITING Ship item")
				("a" "Add to Activity Log")
				("aw" "Walk" entry
				 (file+olp+datetree "~/Documents/Org/fitness.org" "Activity Log")
				 "* Walk - Steps: %^{Steps}, Distance: %^{Distance (m)}m, Time: %^{Time}\nNotes: %?")
				("ar" "Walk" entry
				 (file+olp+datetree "~/Documents/Org/fitness.org" "Activity Log")
				 "* Run - Distance: %^{Distance (m)}m, Time: %^{Time} \nNotes: %?")
				))
  (setq org-refile-targets '(("~/Documents/Org/projects.org" :maxlevel . 3)
                             ("~/Documents/Org/someday.org" :level . 1)
			     ("~/Documents/Org/readinglist.org" :maxlevel . 2)
                           ("~/Documents/Org/tickler.org" :maxlevel . 2)))
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-publish-project-alist
	'(
	  ("articles"
	   :base-directory "~/Documents/Writing/Articles/"
	   :publishing-directory "~/Projects/VastActive.com/org-publish/articles"
	   :publishing-function org-html-publish-to-html
	   :recursive t
	   :exclude ".*\.draft\.org"
	   :auto-sitemap t
	   :sitemap-title "Articles"
	   :html-link-up "sitemap.html"
	   :html-link-home "../index.html"
	   )
	  ("images"
	   :base-directory "~/Documents/Writing/Images"
	   :publishing-dir "~/Projects/VastActive.com/html/images"
	   :recursive t
	   :publishing-function org-publish-attachment
	  )
	  ))
  
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
     (python . t))))
(use-package ox-hugo
  :ensure t
  :pin melpa
  :after ox)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PDF                                                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package pdf-tools)

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
(use-package rustic
  :config
  (setq rustic-lsp-client 'eglot))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom Variables                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("046e442b73846ae114d575a51be9edb081a1ef29c05ae5e237d5769ecfd70c2e" default))
 '(org-export-backends '(ascii html icalendar latex md odt gemini))
 '(package-selected-packages
   '(ox-hugo vscode-icon all-the-icons-dired dired-sidebar org-anki anki-editor modus-operandi-theme ox-gemini org-modern yaml-mode nix-mode dbus-codegen rainbow-delimeters company paredit rainbow-delimiters pdf-tools adoc-mode pyvenv lsp-mode org-contrib org-bullets olivetti valign python-black elpher ox-epub mixed-pitch esup treemacs-all-the-icons writeroom-mode writegood-mode poet-theme))
 '(tool-bar-mode nil)
 '(warning-suppress-log-types '((comp)))
 '(warning-suppress-types '((emacs) (emacs) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-header-face-1 ((t (:inherit default :foreground "#000000" :family "Spectral SC" :weight normal :height 1.0))))
 '(markdown-header-face-2 ((t (:inherit default :foreground "#000000" :family "Spectral SC" :weight normal :height 1.0))))
 '(markdown-header-face-3 ((t (:inherit default :foreground "#000000" :family "Spectral SC" :weight normal :height 1.0))))
 '(markdown-header-face-4 ((t (:inherit default :foreground "#000000" :family "Spectral SC" :weight normal :height 1.0))))
 '(markdown-header-face-5 ((t (:inherit default :foreground "#000000" :family "Spectral SC" :weight normal :height 1.0))))
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
