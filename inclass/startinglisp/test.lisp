#!/usr/bin/sbcl --script

(defvar l)

(defun bubble-sort (lst)
  (loop repeat (1- (length lst)) do
    (loop for ls on lst while (rest ls) do
      (when (> (first ls) (second ls))
        (rotatef (first ls) (second ls)))))
  lst)

(setf l (list  3 7 3 1 5 7))
(print l)
;(pop l)
;(print l)
;(push 3 l)
;(print l)
(terpri)
(bubble-sort l)
(print l)
(terpri)