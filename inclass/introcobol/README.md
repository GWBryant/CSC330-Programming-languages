# introcobol

This program, which I have named tread.cob, is from a tutorial on COBOL found at

https://turreta.com/2014/11/27/how-to-read-file-in-cobol/

Please review that web page for a description of what each line
of the program does.   The program will not compile with Gnu Cobol
because it is missing an identifcation section.

At the top of the program place the following lines
```
      IDENTIFICATION DIVISION.
      PROGRAM-ID. tread.
```

and then compile the program with the command

```
cobc -x tread.cob
```

this should produce a program executable called tread.  Run the program
by simply typing ./tread.


