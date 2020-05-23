;;; updated to autoload any packages that are not alreay loaded

(fset 'yes-or-no-p 'y-or-n-p) ; stops having to type 'yes' when y will do
;; (setq kill-buffer-query-functions
;;       (remq 'process-kill-buffer-query-function
;; 	             kill-buffer-query-functions))

(global-prettify-symbols-mode 1) ;makes lambda turn into the symbol

;possible fix for C-SPC in terminus
(global-set-key (kbd "§") 'set-mark-command)

;;; to enable thing at point mode
(require 'thingatpt)



;;haskell mode stuff
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-to-list 'completion-ignored-extensions ".hi")
(eval-after-load 'haskell-mode '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))
;;(global-set-key (kbd "C-c C-l") 'inf-haskell-mode)

;;start full screen
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;;(setq default-frame-alist '((font . "Source Code Pro-18")))
(add-to-list 'default-frame-alist
                       '(font . "DejaVu Sans Mono-18"))

(setq next-line-add-newlines t) ;this means moving beyond the end of the file adds newlines

;try to set guile as the default scheme
(setq geiser-default-implementation 'guile)

;add to the load path
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/.emacs.d/lisp/bookmark-plus/")

;;**************work around********
;;this fixes the emacs 26 TLS bug
;(setq package-archives '(("gnu" . "http://mirrors.163.com/elpa/gnu")))
;not needed now I can build 26.3 on the Pi

;; the melpa emacs package archive
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;;; latest org mode
(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;;get emacs to auto-install any packages it needs that are not already installed
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

;; (use-package ace-jump-mode)

(setq package-list '(org-plus-contrib projectile flx-ido ace-window auto-complete avy cider clojure-mode deft evil geiser goto-chg haskell-mode horoscope hydra linum-relative lv magit git-commit multiple-cursors org-chef paredit parseedn parseclj a pkg-info epl pomidor alert log4e gntp queue rainbow-delimiters sesman smartparens smex spinner transient dash undo-tree use-package bind-key with-editor apache-mode bar-cursor bm boxquote browse-kill-ring csv-mode diminish eproject folding graphviz-dot-mode helm helm-core async htmlize initsplit markdown-mode popup session tabbar json-mode edit-indirect expand-region))

(package-initialize)
(package-refresh-contents)
(unless package-archive-contents (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))





;;; allows us to expand or contract slections as point
(use-package expand-region)
(global-set-key (kbd "M-'") 'er/expand-region)
(global-set-key (kbd "M-\\") 'er/contract-region)

;;; projectile
(require 'projectile)
(define-key projectile-mode-map  (kbd "C-c p") 'projectile-command-map )
(projectile-mode +1)



;set up emacs be able to work with encrypted files
(require 'epa-file)
;(epa-file-enable)
(setq epa-pinentry-mode 'loopback) ;this allows passphrase to be entered directly in emacs
(setq epa-file-cache-passphrase-for-symmetric-encryption nil) ;ask for password to decrypt

;;bookmarks
;(require 'bookmark)
(setq bookmark-default-file "~/Dropbox/notes/EmacsDict/bookmarks")

;; ;; ;;this lot loads the latest version of bookmarks+ from emacs wiki
;;  (let ((bookmarkplus-dir "~/.emacs.d/lisp/bookmark-plus/")
;;        (emacswiki-base "https://www.emacswiki.org/emacs/download/")
;;        (bookmark-files '("bookmark+.el" "bookmark+-mac.el" "bookmark+-bmu.el" "bookmark+-key.el" "bookmark+-lit.el" "bookmark+-1.el")))
;;   (require 'url)
;;   (add-to-list 'load-path bookmarkplus-dir)
;;   (make-directory bookmarkplus-dir t)
;;   (mapcar (lambda (arg)
;; 	    (let ((local-file (concat bookmarkplus-dir arg)))
;; 	      (unless (file-exists-p local-file)
;; 		(url-copy-file (concat emacswiki-base arg) local-file t))))
;; 	  bookmark-files)
;;   (byte-recompile-directory bookmarkplus-dir 0)
 (require 'bookmark+)

;;(require 'bookmark+)


;;this puts the last selected bookmark at the top of the list (not sure it works though)
 ;; (defadvice bookmark-jump (after bookmark-jump activate)
 ;;  (let ((latest (bookmark-get-bookmark bookmark)))
 ;;    (setq bookmark-alist (delq latest bookmark-alist))
 ;;    (add-to-list 'bookmark-alist latest)
 ;;   ; (setq TEMP bookmark-alist)
 ;;    ))

;;set to save bookmarks file whenever it is changed
(setq bookmark-save-flag 1)


;;semantic refactoring
;; (require 'srefactor)
;; (require 'srefactor-lisp)

;; (semantic-mode 1)
;; (global-set-key (kbd "C-c rp") 'srefactor-refactor-at-point)
;; (global-set-key (kbd "C-c rs") 'srefactor-lisp-format-sexp)
;; (global-set-key (kbd "C-c rd") 'srefactor-lisp-format-defun)
;; (global-set-key (kbd "C-c rb") 'srefactor-lisp-format-buffer)


(load-file "~/.emacs.d/lisp/adaptive-wrap.el")
;(adaptive-wrap-prefix-mode 1)

;adaptive-wrap-prefix-mode doesnt have a global mode, but it depends upon visual-line-mode which does so; add a hook to enable it whenever the latter is on
(add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode)
(global-visual-line-mode 1)
;just load visual line mode in org files only
(with-eval-after-load 'org
  (setq org-startup-indented t)
  (add-hook 'org-mode-hook #'visual-line-mode))


;;fly spell ENABLE
;(dolist (hook '(text-mode-hook))
;  (add-hook hook (lambda () (flyspell-mode 1))))
(setq flyspell-issue-message-flag nil) ;;to improve performance
(setq ispell-personal-dictionary "~/Dropbox/notes/EmacsDict/.aspell.en.pws")

(use-package flyspell
  :ensure t
  :defer 1
  :custom
  (flyspell-abbrev-p t)
  (flyspell-issue-message-flag nil)
  (flyspell-issue-welcome-flag nil)
    (flyspell-mode 1))



;;quick searching a-la notational velocity
;; create a symlink like this
;; ln -s ~/Dropbox/notes ~/.deft

(require 'deft)
(global-set-key "\C-cd" "\M-x deft")
(setq deft-use-filename-as-title t)
(setq deft-directory "~/Dropbox/notes") ;;no need to do the symlink thingy above now
(setq deft-extensions '("org" "txt" "tex" "md" "markdown" "py" "el" "c" "tjp" "scm" "hs"))
(setq deft-default-extension "md")
;try to reduce the autosaves in deft (so we don't have huge number of backups)
(setq deft-auto-save-interval 300.0)

(require 'hydra)

(require 'smartparens-config) ;;this is in smartparens.el too
;;(load-file "~/.emacs.d/lisp/smartparens.el") needs hydra to work and has bugs it seems

(load-file "~/.emacs.d/lisp/myhydras.el")
;;use C-c h be the prefix for all my hydra menus
(use-package hydra
  :bind ("C-c h o" . hydra-global-org/body))
(use-package hydra
  :bind ("C-c h p" . smartparens-hydra/body))
(use-package hydra
  :bind ("C-c h s" . hydra-spelling/body))


;;this enables C-c C-w to duplicate the line and move to the start of it
(global-set-key "\C-c\C-w" "\C-a\C- \C-n\M-w\C-y\C-p") 

;;********* lispy bracket stuff for emlisp and scheme

;; auto close bracket insertion. New in emacs 24
(electric-pair-mode 1)
;; highlight matching parens too
(setq show-paren-delay 0)
(show-paren-mode 1)
; paredit mode

(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook #'enable-paredit-mode)
(add-hook 'lisp-mode-hook #'enable-paredit-mode)
(add-hook 'clojure-mode-hook #'enable-paredit-mode)
;load the handy menu whenever we load paredit
(require 'paredit-menu)

;to make termius work better in paredit mode and other things
(add-hook 'term-setup-hook
	  '(lambda ()
	     (define-key function-key-map "^[^F" [C-M-f])
	     (define-key function-key-map "^[^B" [C-M-b])
	     (define-key function-key-map "M-," [C-M-u]) ;think M-<
	     (define-key function-key-map "M-." [C-M-d]) ;think M->
	     (define-key function-key-map "^[^p" [C-M-p])
	     (define-key function-key-map "^[^n" [C-M-n])
	     (define-key function-key-map "^[[1;5C" [C-right])  ;;slurp
	     (define-key function-key-map "^[[1;5D" [C-left])   ;;barf
	     (define-key function-key-map "^[b" [C-M-left])
	     (define-key function-key-map "^[f" [C-M-right])
	     (define-key function-key-map "^[[20~" [(kbd  "M-(")])  ;;since shift-M-9 looks like f9
	    
	    ;; (define-key function-key-map "^[\\" [(kbd  "M-\\")]) 
	     
	     ;; these four don't work - not sure why
	     (define-key function-key-map "^[b" [M-left]) ;org-mode promote heading 
	     (define-key function-key-map "^[f" [M-right]) ;org-mode demote heading
	     (define-key function-key-map "^[R" [M-S-up]) ;org-mode swap with prev subtree
	     (define-key function-key-map "^[Q" [M-S-down]) ;org-mode swap with next subtree

	     )
	  )




;;word count mode
(setq load-path (cons (expand-file-name "~/.emacs.d/lisp") load-path))
(autoload 'word-count-mode "word-count"
          "Minor mode to count words." t nil)
(global-set-key "\M-=" 'word-count-mode)

;;pretty indentation C-x h to select whole buffer and then
(global-set-key "\C-\M-z" 'indent-region)
;(global-set-key (kbd ";") (kbd "<C-u>2;")) - doesn't work


;;a really simple pomodoro timer
;; (defun pomodoro ()
;;   (interactive)
;;   (run-at-time (* 25 60) nil (lambda () (message "\n\n\n\n\n******************************\nTime's up\nLet's take a break\n******************************\n\n\n\n")
;; 					 (switch-to-buffer "*Messages*")
;; 			      (ding))))

;;a better one I found on the internet lol!
(add-to-list 'load-path "~/.emacs.d/pomidor/")
(require 'pomidor)




;;enable ido mode fuzzy completion
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(require 'flx-ido) ;; a better ido
(flx-ido-mode 1)

;;bump up the cut/copy buffer from its default of 60 - never lose anything you delete!
(setq kill-ring-max 1024)

;;reduce the amount of characters typed between auto-saves from 300 and the time before saving
;;when idle
(setq auto-save-interval 100)
(setq auto-save-timeout 10)

      
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;;function to create a new empty buffer
(defun mark-new-buffer-frame ()
  "Create a new frame with a new empty buffer."
  (interactive)
  (let ((buffer (generate-new-buffer "untitled")))
    (set-buffer-major-mode buffer)
        (display-buffer buffer '(display-buffer-pop-up-frame . nil))))
;;bind this to C-c n
(global-set-key (kbd "C-c n") #'mark-new-buffer-frame)

;;enable rainbow-brackets in programming modes
;;first download package using M-x package-install RET rainbow-delimiters RET
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;enable relative line numbering - don't really need with ace-jump mode on
;;M-x package-install linum-relative
;(require 'linum-relative)
;(add-hook 'prog-mode-hook #'linum-relative-mode)

;;enable org mode
;(require 'org)
;;but start with all levels open when we open a file
;;(setq org-startup-folded nil)  ;;actually its better to start with the default closed

;;org agenda keys from p3 of org-mode manual
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitch)

;;set the default location for capturing notes
(setq org-directory "~/Dropbox/notes")
(setq org-default-notes-file (concat org-directory "/org-notes.org"))
(setq my-journal-file (concat org-directory "/org-journal.org"))
(setq my-ideas-file (concat org-directory "/org-ideas.org"))
(setq my-post-it-file (concat org-directory "/Post-It.org"))

;set the done archive
;(setq org-archive-location (concat org-directory “/archived.org”))

;; set up some simple templates for todo, ideas and journal
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-notes-file  "Tasks")
	 "* TODO  %?\n Entered on %U\n %i\n %a ")
	("p" "Post-It" entry (file+headline my-post-it-file "Post-It Notes")
	 "* %?\n Entered on %U\n %i\n %a ")
	("j" "Journal" entry (file+datetree my-journal-file)
	 "* %?\n Entered on %U\n %i\n %a")
	("i" "Ideas" entry (file+datetree my-ideas-file)
	 "* %?\nEntered on %U\n %a")))



;;set the files for org-mode refile - all headings within opened org mode files
(defun +org/opened-buffer-files ()
  "Return the list of files currently opened in emacs"
  (delq nil
	(mapcar (lambda (x)
		  (if (and (buffer-file-name x)
			   (string-match "\\.org$"
					 (buffer-file-name x)))
		      (buffer-file-name x)))
		(buffer-list))))

(setq org-refile-targets '((+org/opened-buffer-files :maxlevel . 9)))

;;******************************* Filing away DONE tasks ************************


;;a function to refile done tasks into a single file
(setq org-archive-location (expand-file-name (concat org-directory "/DONE.org_archive::")))

;this will file a single task if its the currently selected one and its status is done
(defun archive-when-done ()
  "Archive current entry if it is marked as DONE (see `org-done-keywords')."
  (when (org-entry-is-done-p)
        (org-archive-subtree-default)))


;; this function maps the above to each headline in the org file, but for some reason will archive the first DONE item it comes to it and then exit - don't know why, but we've got a workaround!
(defun org-archive-done-tasks1 ()
;  (interactive)
  (org-map-entries 
     'archive-when-done))


;;count the number of entries matching a criteria
;; (defun numdone ()
;;   (interactive) (message (number-to-string
;; (length (org-map-entries t "+/DONE" 'file)))))

;;repeat the map function the right number of times = as many times as there are done items in the list  Strangely the org-map-entries works for selection without exiting
(defun org-archive-done-tasks ()
    (interactive)
  (dotimes (n (length (org-map-entries t "+/DONE" 'file)))(org-archive-done-tasks1)))
;dotimes syntax
;(dotimes (n 5) (print n) )

;map this to C-czd (zap done)
(global-set-key "\C-czd" `org-archive-done-tasks)


;;these commands allow inserting of todays date automatically
(require 'calendar)
;; (defun insdate-insert-current-date (&optional omit-day-of-week-p)
;;       "Insert today's date using the current locale.
;;   With a prefix argument, the date is inserted without the day of
;;   the week."
;;       (interactive "P*")
;;       (insert (calendar-date-string (calendar-current-date) nil
;; 				    omit-day-of-week-p)))
(defun insdate-insert-current-date ()
  (interactive)
        (insert (format-time-string "## %Y-%m-%d-%H-%M-%S \n\n")))

;;bind this to C-c i
 (global-set-key "\C-ci" `insdate-insert-current-date)


;;This makes emacs use uk convention of only one space after full-stop (period) to the snetence jump commands work
(setq sentence-end-double-space nil)

;;this enable automatic capitalisation at the start of sentences
(load-file "~/.emacs.d/lisp/auto-capitalize.el")
(add-hook 'text-mode-hook 'turn-on-auto-capitalize-mode)

;;This makes typing two spaces after a word produce a full-stop just like iOS devices do
;;I had to modify this adding the progn and expand abbrev - beacause otherwise abbrev didn't
;;work on org-mode for some reason
(defun freaky-space ()
  (interactive)
  (progn (expand-abbrev) (cond ((looking-back "\\(?:^\\|\\.\\)  +")
	 (insert " "))
	((eq this-command
	     last-command)
	 (backward-delete-char 1)
	 (insert ". "))
	(t
	 (insert " ")))))

(define-key text-mode-map " " 'freaky-space)
        

;;remap beginning of buffer as M-< doesn't work on Terminus with linode
;;however I have found that C-x [ and C-x ] go to start and end of buffer
(global-set-key (kbd "M-1") 'beginning-of-buffer)
(global-set-key (kbd "M-0") 'end-of-buffer)

;;because Terminus doesnt like this symbol, but we need it for markdown and task-juggler comments
(global-set-key (kbd "M-3") (lambda () (interactive) (insert "#")))

;;rebind the org-mode keys which don't wprk when using terminus and linode

;;because M-RETURN doesn't work
(global-set-key (kbd "M-]") 'org-meta-return)

;;because M-<UP> doesn't work remember C-p is same as UP
(global-set-key (kbd "M-p") 'org-move-subtree-up)

;;because M-<DOWN> doesn't work C-n is same as DOWN
(global-set-key (kbd "M-n") 'org-move-subtree-down)

;;because M-<RIGHT> doesn't work . is on the same key as >
(global-set-key (kbd "M-.") 'org-do-demote)

;;because M-<LEFT> doesn't work , is on the same key as <
(global-set-key (kbd "M-,") 'org-do-promote)

;;evil mode

;;type
;;  M-x package-refresh-contents
;;  M-x package-install RET evil
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "/home/mark/Dropbox/notes/EmacsDict/bookmarks")
 '(font-use-system-font t)
 '(org-agenda-files
   (quote
    ("~/Dropbox/notes/org-notes.org" "~/Dropbox/notes/personallist.org" "~/Dropbox/notes/worklist.org")))
 '(package-selected-packages
   (quote
    (hl-anything thingopt cider haskell-mode visual-fill writeroom-mode srefactor geiser adaptive-wrap deft hydra smartparens pomidor magit multiple-cursors horoscope smex auto-complete linum-relative rainbow-delimiters org-chef evil)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans" :foundry "PfEd" :slant normal :weight normal :height 158 :width normal)))))
;;manually add this
(require 'evil)
;(evil-mode 1)
;;this makes the default buffer state emacs mode - use C-z to go to evil mode and back
;(setq evil-motion-state-modes (append evil-emacs-state-modes evil-motion-state-modes))
;(setq evil-emacs-state-modes nil)

;;use M-TAB to go in and out of evil mode
;(global-set-key (kbd "M-+") 'evil-local-mode)


;;toggle evil mode and emacs N and E using M-u
;;The reason for this is that there's not much point in VIM insert mode - just use emacs
;;but VIM normal mode and visual mode are pretty useful so be able to use them

(defun toggle-evilmode ()
(interactive)
(if (bound-and-true-p evil-local-mode)
    (progn
					; go emacs
      (evil-local-mode (or -1 1))
      (undo-tree-mode (or -1 1))
      (set-variable 'cursor-type 'bar)
      )
  (progn
					; go evil
    (evil-local-mode (or 1 1))
    (set-variable 'cursor-type 'box)
    )
  )
)

(global-set-key (kbd "M-u") 'toggle-evilmode)



;; ************************Org Chef********************
;; org-mode recipes
;;
;;this bit downloads org-chef

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(require 'use-package)

(use-package org-chef
	       :ensure t)


;; this sets up org-capture for org-chef
(setq my-recipes-file (concat org-directory "/org-recipes.org"))



(setq org-capture-templates (append org-capture-templates 
      '(("c" "Cookbook" entry (file my-recipes-file)
	 "%(org-chef-get-recipe-from-url)"
	 :empty-lines 1)
	("m" "Manual Cookbook" entry (file my-recipes-file)
	          "* %^{Recipe title: }\n  :PROPERTIES:\n  :source-url:\n  :servings:\n  :prep-time:\n  :cook-time:\n  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n"))))





;;******************************end of org-chef stuff*************************

;;******************************random quote code*************************

;;; @(#) random-quote.el -- chooses a random quote from a file
;;; @(#) $Id$

;; This file is not part of Emacs

;; Copyright (C) 2006 by Alessandro Di Marco
;; Author:          Alessandro Di Marco (dmr@gmx.it)
;; Maintainer:      Alessandro Di Marco (dmr@gmx.it)
;; Created:         April 26, 2006
;; Keywords:        quote random
;; Latest Version:

;; COPYRIGHT NOTICE

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:
;;
;;  random-quote provides a simple mechanism to pick a random quote in a
;;  file. It is sufficient to put the file name containing the quotes in the
;;  `random-quote-file' variable. Next, at each invocation of
;;  `pick-random-quote', a string containing a random quote will be
;;  returned. The `random-quote-file' format has been kept as simpler as
;;  possible; at moment it simply consists in a quote per line.

;;; Installation:
;;
;;  Put this file on your Emacs-Lisp load path, then add one of the following
;;  to your ~/.emacs startup file.  You can load random-quote every time you
;;  start Emacs:
;;
;;     (require 'random-quote)

;;; Usage:
;;
;;  Do you really need help for this?

;;; Known Bugs:
;;
;;  Too simple to have one (hopefully ;-)

;;; Comments:
;;
;;  Any comments, suggestions, bug reports or upgrade requests are welcome.
;;  Please send them to Alessandro Di Marco (dmr@gmx.it).
;;
;;  This version of random-quote was developed and tested with GNU Emacs
;;  22.0.50.1 under Linux. Please, let me know if it works with other OS and
;;  versions of Emacs.

;;; Change Log:
;;
;;

(defvar random-quote-file (expand-file-name "~/Dropbox/notes/.quotes")
  "*Pathname of a file containing quotes. One quote per line.")

(defun pick-random-quote ()
    "Returns a string containing a randomly selected quote,
picked from random-quote-file."
    (interactive)
    (save-excursion
      (let ((quote-buf
	     (find-file-noselect random-quote-file)))
	(set-buffer quote-buf)
	(bury-buffer quote-buf)
	(if (> (random 100) 90)
	    (random t))
	(let ((quote-buf-lines
	       (count-lines 1 (buffer-size))))
	  (let ((quote-random-line
		 (+ (random quote-buf-lines) 1)))
	    (goto-line quote-random-line)
	    (beginning-of-line)
	    (let ((beg (point)))
	      (end-of-line)
	      (let ((end (point))
		    (temp-buf
		     (generate-new-buffer "prqbuf")))
		(set-buffer temp-buf)
		(bury-buffer temp-buf)
		(insert-buffer-substring quote-buf beg end)
		(fill-region 1 (- end beg) 'left)
		(let ((indented-string
		       (buffer-substring 1 (+ (buffer-size) 1))))
		  (kill-buffer temp-buf)
		  (kill-buffer quote-buf)
		  indented-string))))))))

(provide 'random-quote)

;;******************************


;;persisting the history between emacs sessions.....awesome!
(setenv "SYSENV" "work")

(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring last-kbd-macro kmacro-ring shell-command-history))
(setq kmacro-ring-max 42)
(setq history-delete-duplicates t)
(if (equal "work" (getenv "SYSENV"))
    (if (file-exists-p "~/workorg")
	(setq savehist-file "~/workorg/emacshistory")
      )
  (if (file-exists-p "~/Dropbox/notes/emacshistory")
      (setq savehist-file "~/Dropbox/notes/emacshistory/emacshistory")
    )
  (if (file-exists-p savehist-file)
      (load-file savehist-file)
    )

  )
 (savehist-mode 1)



;;set location
(setq calendar-latitude 51.8080555556)
(setq calendar-longitude -3.13194444445)
     (setq calendar-location-name "Clydach, Brecon Beacons National Park")
;;set local time
(set-time-zone-rule "GMT-1")

;;*****************Make emacs do some custom things on start up************

(add-hook 'emacs-startup-hook 'my-startup-fcn)
(defun my-startup-fcn ()
  "do fancy things"
  (let ((my-buffer (get-buffer-create "*my-buffer*")))
    (with-current-buffer my-buffer
      ;; this is what you customize
      (insert "Every day is a fresh start\n\n")
      (insert (calendar-date-string (calendar-current-date)))
      (insert "\n\n")
      (insert (format-time-string "%y-%m-%d %H-%M-%S \n\n"))
      ;;the number of days elapsed this year
      (insert (number-to-string (time-to-day-in-year (current-time))))
      (insert "\n\n")
      ;;the number of days left to go this year
      (insert (number-to-string (org-time-stamp-to-now "2020-12-31")))
      (insert "\n\n")
      ;; the number of days until I am 60
      ;;(insert (number-to-string (org-time-stamp-to-now "2028-01-07")))
      (insert "\n\n")
      (insert (sunrise-sunset))
      (insert "\n\n")
      ;;(insert (pick-random-quote))
      )
    (switch-to-buffer my-buffer)))



;;***************************************************************************
(setq initial-buffer-choice "my-buffer")



;;***************************geiser*****************************************
;;sets up a REPL for scheme (such as geiser)
;(require 'geiser-install)



;;****************************org-babel************************************
;;add further languages here as required

(org-babel-do-load-languages
  'org-babel-load-languages
    '((python . t)))

(org-babel-do-load-languages
  'org-babel-load-languages
    '((ditaa . t)))

(org-babel-do-load-languages
  'org-babel-load-languages
    '((emacs-lisp . t)))

(org-babel-do-load-languages
  'org-babel-load-languages
    '((scheme  . t)))

(setq org-babel-clojure-backend 'cider)
(require 'cider)

(org-babel-do-load-languages
  'org-babel-load-languages
  '((clojure  . t)))




;; task juggler syntax highlighting
(load-file "~/.emacs.d/lisp/tj3-mode.el")
(load-file "~/.emacs.d/lisp/i-ching.el")


;;******************** org-mode jaskjuggler export ********************
(require 'ox-taskjuggler)
(setq org-taskjuggler-target-version 3.7)

;;***************************************ACE JUMP MODE****************************************

;;
;; ace jump mode major function
;;
(add-to-list 'load-path "~/.emacs.d/lisp/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c j") 'ace-jump-mode) ;because C-c SPC was already defined in org mode
(define-key global-map (kbd "M-+") 'ace-jump-mode) ;; this is M-TAB on Terminus!

;;; use avy goto char too
(define-key global-map (kbd "C-c J") 'avy-goto-char)


;;
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;;If you use viper mode :
;;(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
;;If you use evil
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;;ace-window
(global-set-key (kbd "C-x o") 'ace-window)

;;enable auto-complete mode by default M-x package-install RET auto-complete
;(require 'auto-complete)
(use-package auto-complete :config (ac-flyspell-workaround))
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'markdown-mode)
(add-to-list 'ac-modes 'tj3-mode)
(add-to-list 'ac-modes 'text-mode)

(ac-config-default)
(global-auto-complete-mode t)


;;enable smex
(require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command) ;this is the old M-x

;;set up multiple cursors
(require 'multiple-cursors) ;;need to install M-x package-install RET multiple-cursors
;;invoke - when you have an actove region spanning multiple lines - this adds cursors
(global-set-key (kbd "C-c C-m C-c") 'mc/edit-lines)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; backup settings                                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://www.emacswiki.org/emacs/BackupFiles
(setq
 backup-by-copying t     ; don't clobber symlinks
 kept-new-versions 10000    ; keep latest versions
 kept-old-versions 0     ; don't bother with old versions
 delete-old-versions t   ; don't ask about deleting old versions
 version-control t       ; number backups
 vc-make-backup-files t) ; backup version controlled files

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; backup every save                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
;; https://www.emacswiki.org/emacs/backup-each-save.el
(defvar bjm/backup-file-size-limit (* 5 1024 1024)
    "Maximum size of a file (in bytes) that should be copied at each savepoint.

If a file is greater than this size, don't make a backup of it.
Default is 5 MB")

(defvar bjm/backup-location (expand-file-name "~/Dropbox/EmacsBackup")
  "Base directory for backup files.")

;;********TODO******
;;detect if running on pi or computer without dropbox and save somewhere else
;;possibly creating backup folder if it doesn't exist
;;if efiting remotely via Tramp get it to still back up locally not on remote computer

(defvar bjm/backup-trash-dir (expand-file-name "~/.Trash")
  "Directory for unwanted backups.")

(defvar bjm/backup-exclude-regexp "\\[Gmail\\]"
    "Don't back up files matching this regexp.

Files whose full name matches this regexp are backed up to `bjm/backup-trash-dir'. Set to nil to disable this.")

;; Default and per-save backups go here:
;; N.B. backtick and comma allow evaluation of expression
;; when forming list
(setq backup-directory-alist
      `(("" . ,(expand-file-name "per-save" bjm/backup-location))))

;; add trash dir if needed
(if bjm/backup-exclude-regexp
    (add-to-list 'backup-directory-alist `(,bjm/backup-exclude-regexp . ,bjm/backup-trash-dir)))

(defun bjm/backup-every-save ()
    "Backup files every time they are saved.

Files are backed up to `bjm/backup-location' in subdirectories \"per-session\" once per Emacs session, and \"per-save\" every time a file is saved.

Files whose names match the REGEXP in `bjm/backup-exclude-regexp' are copied to `bjm/backup-trash-dir' instead of the normal backup directory.

Files larger than `bjm/backup-file-size-limit' are not backed up."

    ;; Make a special "per session" backup at the first save of each
    ;; emacs session.
    (when (not buffer-backed-up)
      ;;
      ;; Override the default parameters for per-session backups.
      ;;
      (let ((backup-directory-alist
	     `(("." . ,(expand-file-name "per-session" bjm/backup-location))))
	    (kept-new-versions 3))
	;;
	;; add trash dir if needed
	;;
	(if bjm/backup-exclude-regexp
	    (add-to-list
	     'backup-directory-alist
	     `(,bjm/backup-exclude-regexp . ,bjm/backup-trash-dir)))
	;;
	;; is file too large?
	;;
	(if (<= (buffer-size) bjm/backup-file-size-limit)
	    (progn
	      (message "Made per session backup of %s" (buffer-name))
	      (backup-buffer))
	  (message "WARNING: File %s too large to backup - increase value of bjm/backup-file-size-limit" (buffer-name)))))
    ;;
    ;; Make a "per save" backup on each save.  The first save results in
    ;; both a per-session and a per-save backup, to keep the numbering
    ;; of per-save backups consistent.
    ;;
    (let ((buffer-backed-up nil))
      ;;
      ;; is file too large?
      ;;
      (if (<= (buffer-size) bjm/backup-file-size-limit)
	  (progn
	    (message "Made per save backup of %s" (buffer-name))
	    (backup-buffer))
	(message "WARNING: File %s too large to backup - increase value of bjm/backup-file-size-limit" (buffer-name)))))

;; add to save hook
(add-hook 'before-save-hook 'bjm/backup-every-save)

;;this deletes any backup files that havent been accessed for the time period specified
;;need to mnake this a function where the directory is an argument as I have 2
;;per save and per session

(defun delete-old-backups (my-backup-directory)
			 "Deletes old backups...currently after two weeks"
(message "Deleting old backup files...")
(let ((week (* 60 60 24 365))  ;let's just make it a year and see!!
      (current (float-time (current-time))))
  (dolist (file (directory-files my-backup-directory t))
    (when (and (backup-file-name-p file)
	       (> (- current (float-time (fifth (file-attributes file))))
		  week))
      (message "%s" file)
      (delete-file file)))))

(delete-old-backups "~/Dropbox/EmacsBackup/per-session/")
(delete-old-backups "~/Dropbox/EmacsBackup/per-save/")



;;******** magit ********
(global-set-key (kbd "C-x g") 'magit-status)



;;enable abbreviation expansion
(setq abbrev-file-name             ;; tell emacs where to read abbrev
      "~/Dropbox/notes/EmacsDict/abbrev_defs")    ;; definitions from
;(setq save-abbrevs 'silent)        ;; save abbrevs when files are saved
(setq-default abbrev-mode t)       ;;switch it on
(setq save-abbrevs 'silently)       ;; don't prompt for saving on closing emacs



; a function to delete leading whitespace
(defun my-delete-leading-whitespace (start end)
  "Delete whitespace at the beginning of each line in region."
  (interactive "*r")
  (save-excursion
    (if (not (bolp)) (forward-line 1))
    (delete-whitespace-rectangle (point) end nil)))

(global-set-key (kbd "C-c kw") 'my-delete-leading-whitespace)

(global-set-key (kbd "C-c 1") 'just-one-space)
