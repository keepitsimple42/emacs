;; task juggler syntax highlighting
(load-file "~/.emacs.d/tj3-mode.el")

;;enable ido mode fuzzy completion
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;;bump up the cut/copy buffer from its default of 60 - never lose anything you delete!
(setq kill-ring-max 256)

(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;;enable org mode
(require 'org)
;;but start with all levels open when we open a file
(setq org-startup-folded nil)

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

;; set up some simple templates for todo, ideas and journal
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-notes-file  "Tasks")
	 "* TODO  %?\n Entered on %U\n %i\n %a ")
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
(load-file "~/.emacs.d/auto-capitalize.el")
(add-hook 'text-mode-hook 'turn-on-auto-capitalize-mode)

;;This makes typing two spaces after a work produce a full-stop just like iOS devices do
(defun freaky-space ()
  (interactive)
  (cond ((looking-back "\\(?:^\\|\\.\\)  +")
	 (insert " "))
	((eq this-command
	     last-command)
	 (backward-delete-char 1)
	 (insert ". "))
	(t
	 (insert " "))))

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
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

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
 '(package-selected-packages (quote (org-chef evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
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

;;*****************Make emacs to some custom things on start up************

(add-hook 'emacs-startup-hook 'my-startup-fcn)
(defun my-startup-fcn ()
  "do fancy things"
  (let ((my-buffer (get-buffer-create "my-buffer")))
    (with-current-buffer my-buffer
      ;; this is what you customize
      (insert "Every day is a fresh start\n\n")
      (insert (calendar-date-string (calendar-current-date)))
      (insert "\n\n")
      (insert (format-time-string "%y-%m-%d %H-%M-%S \n\n"))
      (insert (sunrise-sunset))
      (insert "\n\n")
      (insert (pick-random-quote)))
    (switch-to-buffer my-buffer)))



;;***************************************************************************
(setq initial-buffer-choice "my-buffer")
