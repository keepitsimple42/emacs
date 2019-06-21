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
 '(package-selected-packages (quote (evil))))
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

