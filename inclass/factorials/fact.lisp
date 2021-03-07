#!/usr/bin/sbcl --script

(defun fact(i)
	(if(= i 0)
		1
		(* i (fact(- i 1)))))

(loop for i from 0 to 34
	do(format t"~D! = ~D~%" i (fact i)))
