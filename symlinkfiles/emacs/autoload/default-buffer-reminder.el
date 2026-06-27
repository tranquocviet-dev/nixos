(defun reminder()
  (interactive)
  (with-current-buffer "*scratch*"
    (goto-char (point-max))
    (insert "Hello World!")))
