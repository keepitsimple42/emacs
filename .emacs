;;Note several of the packages loaded require you to launch emacs and type
;; M-x package-install <RET>  package-name  <RET> the very first time
;;I'll try to list these here (and in the comments in this file too)
;;rainbow-delimiters
;;linum-relative
;;evil
;;auto-complete 
;;smex
;;ace-jump
;;ace-window
;;multiple-cursors
;;smartparens
;;deft

;; the melpa emacs package archive
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;;fly spell ENABLE
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
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
(setq deft-extensions '("org" "txt" "tex" "md" "markdown" "py" "el" "c" "tjp"))
(setq deft-default-extension "md")


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


;;this enables C-c C-d to duplicate the line and move to the start of it
(global-set-key "\C-c\C-w" "\C-a\C- \C-n\M-w\C-y\C-p") 



;; auto close bracket insertion. New in emacs 24
(electric-pair-mode 1)
;; highlight matching parens too
(setq show-paren-delay 0)
(show-paren-mode 1)

;;word count mode
(setq load-path (cons (expand-file-name "~/.emacs.d/lisp") load-path))
(autoload 'word-count-mode "word-count"
          "Minor mode to count words." t nil)
(global-set-key "\M-=" 'word-count-mode)

;;a really simple pomodoro timer
;; (defun pomodoro ()
;;   (interactive)
;;   (run-at-time (* 25 60) nil (lambda () (message "\n\n\n\n\n******************************\nTime's up\nLet's take a break\n******************************\n\n\n\n")
;; 					 (switch-to-buffer "*Messages*")
;; 			      (ding))))

;;a better one I found on the internet lol!
(add-to-list 'load-path "~/.emacs.d/pomidor/")
(require 'pomidor)

;; task juggler syntax highlighting
(load-file "~/.emacs.d/lisp/tj3-mode.el")
(load-file "~/.emacs.d/lisp/i-ching.el")



;;enable ido mode fuzzy completion
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

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

;;enable relative line numbering
;;M-x package-install linum-relative
(require 'linum-relative)
(add-hook 'prog-mode-hook #'linum-relative-mode)

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


;;these commands allow inserting of todays date automatically
(require 'calendar)
(defun insdate-insert-current-date (&optional omit-day-of-week-p)
      "Insert today's date using the current locale.
  With a prefix argument, the date is inserted without the day of
  the week."
      (interactive "P*")
      (insert (calendar-date-string (calendar-current-date) nil
				    omit-day-of-week-p)))

;;bind this to C-x M-d
 (global-set-key "\C-x\M-d" `insdate-insert-current-date)


;;This makes emacs use uk convention of only one space after full-stop (period) to the snetence jump commands work
(setq sentence-end-double-space nil)

;;this enable automatic capitalisation at the start of sentences
(load-file "~/.emacs.d/lisp/auto-capitalize.el")
(add-hook 'text-mode-hook 'turn-on-auto-capitalize-mode)

;;This makes typing two spaces after a word produce a full-stop just like iOS devices do
;;i had to modify this adding the progn and expand abbrev - beacause otherwise abbrev didn't
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
 '(org-agenda-files
   (quote
    ("~/Dropbox/notes/org-notes.org" "~/Dropbox/notes/personallist.org" "~/Dropbox/notes/worklist.org")))
 '(package-selected-packages
   (quote
    (deft hydra smartparens pomidor magit multiple-cursors horoscope smex auto-complete ace-window linum-relative rainbow-delimiters org-chef evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 158 :width normal)))))
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
(setq calendar-latitude 51.6)
(setq calendar-longitude 3.0)
     (setq calendar-location-name "Newport, Gwent")
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
      (insert (number-to-string (org-time-stamp-to-now "2019-12-31")))
      (insert "\n\n")
      ;; the number of days until I am 60
      (insert (number-to-string (org-time-stamp-to-now "2028-01-07")))
      (insert "\n\n")
      (insert (sunrise-sunset))
      (insert "\n\n")
      (insert (pick-random-quote)))
    (switch-to-buffer my-buffer)))



;;***************************************************************************
(setq initial-buffer-choice "my-buffer")



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
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key global-map (kbd "M-+") 'ace-jump-mode) ;; this is M-TAB on Terminus!



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
(require 'auto-complete)
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'markdown-mode)
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
 kept-new-versions 1000    ; keep latest versions
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
(let ((week (* 60 60 24 14))
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
(setq save-abbrevs 'silent)        ;; save abbrevs when files are saved
(setq-default abbrev-mode t)       ;;switch it on
;(setq save-abbrevs 'silently)       ;; don't prompt for saving on closing emacs
