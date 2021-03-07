#!/usr/bin/sbcl --script

(defvar minVal) (defvar maxVal) (defvar maxNum 0)

;function to calculate collatz sequence recursively
(defun calcCollatz (n)
	(cond 
		((= n 1) (return-from  calcCollatz 0))
        ;if number is even divide by 2
		((= (logxor n 1) (+ n 1)) (progn 
        ;check for max number
        (if (> n maxNum) (setq maxNum n))
        (return-from calcCollatz (calcCollatz (/ n 2)))))
        ;if number is odd multiply by 3 and add 1 
		((/= (logxor n 1) (+ n 1) (progn
        ;check for max number
        (if (> n maxNum) (setq maxNum n))
        (return-from calcCollatz (calcCollatz (+ (* n 3) 1))))))
	)
)

;main function
(defun main ()
;get start and end values from stdin
(write-line "Minimum Value: ")
(setq minVal (read))
(write-line "Minimum Value: ")
(setq maxVal (read))

;loop to find max number in collatz sequence
(loop for j from minVal to maxVal
    ;calculates max collatz number in recursive function
    do(calcCollatz j)
)

;print max collatz number
(print maxNum)
(terpri)
)
(main)