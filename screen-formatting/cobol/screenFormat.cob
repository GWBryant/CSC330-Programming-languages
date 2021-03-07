       IDENTIFICATION DIVISION.
       PROGRAM-ID. screenFormat.  
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT InputFile ASSIGN TO fileName
               ORGANIZATION IS SEQUENTIAL.
        
       DATA DIVISION.
       FILE SECTION.
       FD InputFile.
       01 InputString  PIC A(67108864).

       WORKING-STORAGE SECTION.
       01 END-OF-FILE PIC Z(1).
       01 fileName    PIC X(32).

       PROCEDURE DIVISION CHAINING fileName.
       Begin.
          OPEN INPUT InputFile
          READ InputFile
             AT END MOVE 1 TO END-OF-FILE
          END-READ
          
          IF END-OF-FILE = 1
            CLOSE InputFile
          END-IF
          
          MOVE 0 TO END-OF-FILE.
          
          PERFORM UNTIL END-OF-FILE = 1
             DISPLAY FUNCTION TRIM(InputString)
             READ InputFile into InputString
                AT END MOVE 1 TO END-OF-FILE
             END-READ
          END-PERFORM
        CLOSE InputFile.
       STOP RUN.
