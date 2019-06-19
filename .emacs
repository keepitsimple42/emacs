;;enable task juggler syntax highlighting
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
(evil-mode 1)

