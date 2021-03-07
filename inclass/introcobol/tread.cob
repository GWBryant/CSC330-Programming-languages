       IDENTIFICATION DIVISION.
       PROGRAM-ID. tread.  
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CustomerFile ASSIGN TO "../input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD CustomerFile.
       01 CustomerDetails.
          02  CustomerId       PIC X(10).
          02  CustomerName.
              03 Lastname      PIC X(20).
              03 Firstname     PIC X(20).
              03 Middlename    PIC X(20).
       WORKING-STORAGE SECTION.
       01 END-OF-FILE PIC Z(1).

       PROCEDURE DIVISION.
       Begin.
          OPEN INPUT CustomerFile
          READ CustomerFile
             AT END MOVE 1 TO END-OF-FILE
          END-READ
          
          IF END-OF-FILE = 1
            CLOSE CustomerFile
          END-IF
          
          MOVE 0 TO END-OF-FILE.
          
          PERFORM UNTIL END-OF-FILE = 1
             DISPLAY CustomerId SPACE Lastname SPACE Firstname
             READ CustomerFile
                AT END MOVE 1 TO END-OF-FILE
             END-READ
          END-PERFORM
       STOP RUN.
