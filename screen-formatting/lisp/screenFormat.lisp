#!/usr/bin/sbcl --script

;;;defining variables
(defvar fl)
(defvar longString)
(defvar currLine)
(defvar line)
(defvar fWord)
(defvar token)
(defvar trimmedToken)
(defvar lineCount)
(defvar wordCount)
(defvar charCount)
(defvar charCountString)
(defvar j)
(defvar fileName (cadr *posix-argv*))
(defvar shortLine) (defvar longLine)
(defvar longestString) (defvar shortestString)
(defvar minWords) (defvar maxWords)
(defvar shortLineNumber) (defvar longLineNumber)

;;;Instantiating viariables
(setq charCountString "123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*")
(setq longString "")
(setq token "")
(setq currLine "")
(setq j 0)
(setq lineCount 1)
(setq wordCount 1)
(setq charCount 0)
(setq minWords 60) (setq maxWords 0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;function to format numbers out of a string
(defun fmt-word (string)
	(setq fWord "")
	(loop for x across string
      		do(if (or (and (>= (char-code x) 32) (<= (char-code x) 47)) (and (>= (char-code x) 58) (<= (char-code x) 126))) 
			  	(setf fWord(concatenate 'string fWord (list x))))
	)
	(return-from fmt-word fWord)
)
;;;function to count words in a string based off of the number of spaces in the string
(defun count-words (string)
	(loop for x across string
		do(if (eq x #\space) (incf wordCount)))
	(return-from count-words wordCount)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end-functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;loop to read through the input file and append it all to a string
(setq fl (open fileName ) )
      (loop for line = (read-line fl nil :eof) ; stream, no error, :eof value
                  until (eq line :eof)
                        do (if (/= (length line) 0) (prog1 
							(setf longString(concatenate 'string longString (fmt-word line)))
							(setf longString(concatenate 'string longString (list #\space)))
							)
						)
      )
(setf longString(concatenate 'string longString (list #\space)))
(close fl)
;;;format the string (remove numbers)
(write-line charCountString)
;;;loop to tokenize string and print in correct format
(loop for i from 0 to (- (length longString) 1)
	;;;get tokens from string with if statment
	do(if (string= (subseq longString i (+ i 1)) " ")
	(prog1
		(setq token (subseq longString j i)) ;;;give token value
		(setq token (string-left-trim " " token))
		(setq token (string-right-trim " " token)) ;;;trim whitespace out of token

		;;;If theres no characters currently on the line print the line number
		(if (= charCount 0) (prog1 
			;(write-string "       ") 
			(format t "~8d" lineCount) (write-string "  ")
		))
		;;;if the count plus the length of the word is less than 60 and if so it adds it to string buffer
		(cond ( (and (<= (+ charCount (length token)) 60) (> (length token) 0)) (prog1
			(setq charCount (+ charCount (length token)))
			(setf currLine(concatenate 'string currLine token))
			;;;add a space if and only if the current char count isn't already 60
			(if (< charCount 60) (prog1 
				(setf currLine(concatenate 'string currLine (list #\space)))
				(incf charCount)
			))
			(setq j i)))
		;;;if the cchar count is greater than 60 reset variables and check for
		;;;largest and shortest line
		( (> (+ charCount (length token)) 60) (prog1
			(setq currLine (string-left-trim " " currLine))
			(setq currLine (string-right-trim " " currLine))
			(setq wordCount (count-words currLine))
			(if (>= wordCount maxWords) (prog1
				(setq maxWords wordCount)
				(setq longLine lineCount)
				(setq longestString currLine)))
			(if (<= wordCount minWords) (prog1
				(setq minWords wordCount)
				(setq shortLine lineCount)
				(setq shortestString currLine)))
			;;;print out the line
			(write-line (string-left-trim " " currLine))
			;;;reset variable
			(setf currLine "") 
			(setq charCount 0)
			(setq wordCount 1) 
			(incf lineCount)
			)))
	)	
   )	
)
;;;check wordcount again after loop ends to check for the last string
(setq wordCount (count-words (string-left-trim " " currLine)))
;;;check one last time for min and max length string
(if (>= wordCount maxWords) (prog1
	(setq maxWords wordCount)
	(setq longLine lineCount)
	(setq longestString currLine)))
(if (<= wordCount minWords) (prog1
	(setq minWords wordCount)
	(setq shortLine lineCount)
	(setq shortestString currLine)))
;;;print the last line
(write-line (string-left-trim " " currLine))
(write-line "") ;;;print new line
;;;convert longest and shortest string line numbers to string so its right justified
(setq shortLineNumber (write-to-string shortLine))
(setq longLineNumber (write-to-string longLine))
;;;print the longest line and the line number
(write-string "LONG   ") (format t "~8a" longLineNumber) (write-string "     ")
(write-line (string-left-trim " " longestString))
;;;print the shortest line and the line number
(write-string "SHORT  ") (format t "~8a" shortLine) (write-string "     ")
(write-line (string-left-trim " " shortestString))
