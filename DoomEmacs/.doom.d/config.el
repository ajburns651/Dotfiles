(setq doom-theme 'doom-dracula)               ; Sets Emacs theme to doom-dracula
(setq doom-themes-treemacs-theme "Default")   ; Sets treemacs theme to the Default, otherwise it uses Doom icons

(setq org-directory "~/.doom.d/org/")                                  ; Must be set before Org is Loaded
(setq display-line-numbers-type t)                                     ; Can be deleted to hide or changed to be relative
(setq doom-font (font-spec :family "UbuntuMono Nerd Font" :size 25))   ; Sets Emacs wide font, looks best for 4k Monitor

(map! "C-S-v" #'clipboard-yank)                     ; Binds C-S-V to paste, Alt+w is copy

(map! :leader
      (:prefix ("o" . "open")
       :desc "Open Bullet Journal" "b" #'isamert/toggle-side-bullet-org-buffer)) ; binds SPC-o-b to open daily journal

(defun dired-switch-to-dir (path)
  (interactive)
  (dired-jump :FILE-NAME (expand-file-name path)))  ; Function neccessary for shortcuts that jump to a dired directory

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump
       :desc "Open $HOME in dired" "h" (lambda () (interactive) (dired-switch-to-dir "/home/keb/"))
       :desc "Open root in dired"  "r" (lambda () (interactive) (dired-switch-to-dir "/")))
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Create new file" "d c" #'find-file
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map      ; Make h and l go back and forward in dired
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-open-file
  (kbd "<left>") 'dired-up-directory
  (kbd "<right>") 'dired-open-file)

(evil-define-key 'normal peep-dired-mode-map ; Make h and l go back and forward in dired when viewing images
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file
  (kbd "<up>") 'peep-dired-prev-file
  (kbd "<down>") 'peep-dired-next-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(map! :leader                                ; Clones current buffer into other window
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)

(setq dired-open-extensions '(("gif" . "feh")
                              ("jpg" . "feh")
                              ("png" . "feh")
                              ("pdf" . "brave")
                              ("mkv" . "mpv")
                              ("docx" . "brave")
                              ("mp4" . "mpv")))

(setq user-mail-address "ajburns651@gmail.com"
      user-full-name  "Alex Burns"
      mu4e-get-mail-command "mbsync -c ~/.config/mu4e/mbsyncrc -a"
      mu4e-update-interval  300
      mu4e-main-buffer-hide-personal-addresses t
      message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      mu4e-sent-folder "/gmail/Sent"
      mu4e-drafts-folder "/gmail/Drafts"
      mu4e-trash-folder "/gmail/Trash"
      mu4e-maildir-shortcuts
      '(("/gmail/Inbox"      . ?i)
        ("/gmail/Sent Items" . ?s)
        ("/gmail/Drafts"     . ?d)
        ("/gmail/Trash"      . ?t)))

(defun prefer-horizontal-split () ; Prefers Vertical split when creating new window
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t))
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)

(setq load-prefer-newer t)        ; Removes the error when using old doom things with a newer emacs
(setq delete-selection-mode t)    ; Overwrites Selected Text when I am in insert mode

(after! org
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))) ; Makes the org-bullets look nice instead of astricts

(add-hook 'org-mode-hook 'org-fragtog-mode) ; Needed for org-fratog (Pretty equations inline, LaTeX)
(setq org-latex-create-formula-image-program 'dvisvgm)

(use-package org-agenda
  :after org
  :custom
  (org-agenda-prefix-format '((agenda . " %i %-20:c%?-12t%-6e% s")
                (todo   . " %i %-20:c %-6e")
                (tags   . " %i %-20:c")
                (search . " %i %-20:c"))))

(setq org-agenda-custom-commands
'(("d" "Today's Tasks"
   ((tags-todo
     "PRIORITY=\"A\""
     ((org-agenda-files '("~/.doom.d/org/goals.org"))
      (org-agenda-overriding-header "Primary goals this month")))
    (tags-todo
     "PRIORITY=\"C\""
     ((org-agenda-files '("~/.doom.d/org/goals.org"))
      (org-agenda-overriding-header "Secondary goals this month")))
        (tags-todo
         "-{.*}"
         ((org-agenda-files '("~/Dropbox/Org/Inbox.org"))
          (org-agenda-overriding-header "Items From Phone")))
        (agenda "" ((org-agenda-span 1)
                    (org-agenda-overriding-header "Today")))))

  ("w" "This Week's Tasks"
   ((tags-todo
     "PRIORITY=\"A\""
     ((org-agenda-files '("~/.doom.d/org/goals.org"))
      (org-agenda-overriding-header "Primary goals this month")))
    (tags-todo
     "PRIORITY=\"C\""
     ((org-agenda-files '("~/.doom.d/org/goals.org"))
      (org-agenda-overriding-header "Secondary goals this month")))
    (tags-todo
     "-{.*}"
     ((org-agenda-files '("~/Dropbox/Org/Inbox.org"))
      (org-agenda-overriding-header "Items From Phone")))
    (agenda)))))

(use-package! org-super-agenda        ; Sets the Date for Org-Agenda
    :config
    (setq org-agenda-start-day nil))  ; today

(setq org-agenda-files (directory-files-recursively "~/Dropbox/Org/" "\\.org$")) ; Adds All org files from Dropbox to Agenda
(setq org-agenda-files (remove "~/Dropbox/Org/WorkHours.org" org-agenda-files))  ; Removes WorkHours from Agenda View

(defun org-agenda-auto-refresh-agenda-buffer () ; Auto updates Agenda Buffer if a new file is synced from phone
  (when (org-agenda-file-p)
    (when-let ((buffer (get-buffer org-agenda-buffer-name)))
      (with-current-buffer buffer
	(org-agenda-redo-all)))))
(add-hook 'after-revert-hook #'org-agenda-auto-refresh-agenda-buffer)

(after! org
        (setq org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"                 ; A task that is ready to be tackled
             "PROG(p)"                 ; Something That is in progress
             "BLOCKED(b)"              ; Things That are not my choice to wait on
             "WAITING(w)"              ; Things Im Waiting on
             "|"                       ; Separeates done tasks from not done ones
             "DONE(d)"                 ; Task has been completed
             "CANCELLED(c)" )))        ; Task has been cancelled
        (setq org-todo-keyword-faces
                '(("TODO")
                  ("PROG" . "yellow")
                  ("CANCELLED" . "red")
                  ("WAITING" . "white")
                  ("DONE" . "green")
                  ("BLOCKED" .  "lightblue")))
        (setq org-log-done 'time))     ; Adds a closed timestamp when marking tasks as done

(setq treemacs-persist-file "~/.doom.d/treemacs-persist")
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (treemacs-follow-mode t)))

(defun isamert/toggle-side-bullet-org-buffer () ; Function that toggles journal
  "Toggle `bullet.org` in a side buffer for quick note taking.  The buffer is opened in side window so it can't be accidentaly removed."
  (interactive)
  (isamert/toggle-side-buffer-with-file "~/Dropbox/Org/bullet.org"))

(defun isamert/buffer-visible-p (buffer)
 "Check if given BUFFER is visible or not.  BUFFER is a string representing the buffer name."
  (or (eq buffer (window-buffer (selected-window))) (get-buffer-window buffer)))

(defun isamert/display-buffer-in-side-window (buffer)
  "Just like `display-buffer-in-side-window' but only takes a BUFFER and rest of the parameters are for my taste."
  (select-window
   (display-buffer-in-side-window
    buffer
    (list (cons 'side 'right)
          (cons 'slot 0)
          (cons 'window-width 84)
          (cons 'window-parameters (list (cons 'no-delete-other-windows t)
                                         (cons 'no-other-window nil)))))))

(defun isamert/remove-window-with-buffer (the-buffer-name)
  "Remove window containing given THE-BUFFER-NAME."
  (mapc (lambda (window)
          (when (string-equal (buffer-name (window-buffer window)) the-buffer-name)
            (delete-window window)))
        (window-list (selected-frame))))

(defun isamert/toggle-side-buffer-with-file (file-path)
  "Toggle FILE-PATH in a side buffer. The buffer is opened in side window so it can't be accidentaly removed."
  (interactive)
  (let ((fname (file-name-nondirectory file-path)))
  (if (isamert/buffer-visible-p fname)
      (isamert/remove-window-with-buffer fname)
    (isamert/display-buffer-in-side-window
     (save-window-excursion
       (find-file file-path)
       (current-buffer))))))

(add-hook 'emacs-startup-hook 'treemacs)                     ; Auto open treemacs on launch
(add-hook 'after-init-hook (lambda () (org-agenda nil "w"))) ; Auto open agenda to weekly view
