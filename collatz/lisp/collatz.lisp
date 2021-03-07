#!/usr/bin/sbcl --script

(defvar i) (defvar ic) (defvar numArr) (defvar lArr) (defvar rArr (list 0))

;method to sort a list of lists based on first element in each sublist
(defun sortList (lst)
  (loop repeat (1- (length lst)) 
  do (loop for ls on lst while (rest ls) 
    do(when (> (first (first ls)) (first (second ls)))
        (rotatef (first ls) (second ls)))))
  lst)

;method to check if an item is in a list
(defun inList (item sequence) (if (member item sequence) T NIL))

(defun main ()

;instantiate listss
(setq numArr (list 1 2 3 4 5 6 7 8 9 10))
(setq lArr (list (list 1 1) (list 2 2) (list 3 3) (list 4 4) (list 5 5) (list 6 6) (list 7 7) (list 8 8) (list 9 9) (list 10 10)))

;main loop
(loop for j from 1 to 5000000000
    do(setq i j)
    do(setq ic 0)
    ;loop to calculate collatz sequence length
    do(loop while (/= i 1)
        do(if (= (logxor i 1) (+ i 1)) (setq i (floor i 2)) (setq i (+ (* i 3) 1)))
        do(incf ic)
    )
    ;check if sequence length is larger than smallest of top 10 sequence lengths
    ;Also check if it is already in the array of largets sequence lengths
    do(if (and (> ic (first numArr)) (not (inList ic numArr))) (prog1
        (pop numArr)
        (push ic numArr)
        (pop lArr)
        (push (list ic j) lArr)
        (sort numArr '<)
        (sortList lArr)
    ))
)


(format t "Sorted by sequence length:~%")
(terpri)
(loop for n from 0 to 9
    do(format t "A starting value of ~D has ~D steps ~%" (second (elt lArr n)) (first (elt lArr n)))
)
;create another list that has flipped sublists for sorting purposes
(pop rArr)
(loop for l in lArr
    do(push (reverse l) rArr)
)
;sort reversed list
(sortList rArr)
(format t "Sorted by number size:~%")
(loop for n from 0 to 9
    do(format t "A starting value of ~D has ~D steps ~%" (first (elt rArr n)) (second (elt rArr n)))
)
)

(main)
