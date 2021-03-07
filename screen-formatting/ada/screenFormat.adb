with Ada.Text_IO; use Ada.Text_IO; --import for text io
with ADA.Command_line; use Ada.Command_line;    --import for command line arguments
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;  --unbounded strings for input
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;    --used to output unbounded strings
with Ada.Strings; use Ada.Strings;  --needed for trimming strings
with ada.Integer_Text_IO; use ada.Integer_Text_IO;  --needed to format integers

procedure screenFormat is

    --instantiate variables
    In_File : Ada.Text_IO.File_Type;
    input_string : Unbounded_String;
    Formatted_string : Unbounded_String;
    CharCounter_string : Unbounded_String;
    Line : Unbounded_String;
    Token : Unbounded_String;
    longLine,shortLine, longLineNumber, shortLineNumber : Unbounded_String;
    isLetter : Boolean;
    j,wordCount,LineCount,charCount : Integer;
    maxWords, minWords, maxLine, minLine : Integer;
    fileName : String := argument(1);

begin

    --open the file
    Ada.Text_IO.Open (File => In_File, Mode => Ada.Text_IO.In_File, Name => fileName);
    --loop through the file and append each line to a unbounded string with a space
    while not Ada.Text_IO.End_Of_File(In_File) loop
        Append(Source => input_string, New_Item => Ada.Text_IO.Get_Line(File => In_File));
        Append(Source => input_string, New_Item => " ");
    end loop;
    Append(Source => input_string, New_Item => " ");
    
    Append(Source => CharCounter_string, New_Item => "123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*");

    --strip numbers out of string
    for i in 1..(length(input_string)) loop
        isLetter := True;
        if element(input_string,i) = '0' then
            isLetter := False;
        elsif element(input_string,i) = '1' then
            isLetter := False;
        elsif element(input_string,i) = '2' then
            isLetter := False;
        elsif element(input_string,i) = '3' then
            isLetter := False;
        elsif element(input_string,i) = '4' then
            isLetter := False;
        elsif element(input_string,i) = '5' then
            isLetter := False;
        elsif element(input_string,i) = '6' then
            isLetter := False;
        elsif element(input_string,i) = '7' then
            isLetter := False;
        elsif element(input_string,i) = '8' then
            isLetter := False;
        elsif element(input_string,i) = '9' then
            isLetter := False;
        end if;
        --if the character is not a number then append it to the formatted string
        if isLetter then
            Append(Source => Formatted_string, New_Item => element(input_string,i));
        end if;
    end loop;

    Put_Line(CharCounter_string);
    --set values for variables
    j := 1;
    maxWords := 0;
    minWords := 60;
    wordCount := 1;
    charCount := 0;
    lineCount := 1;
    --loop through unbounded string and append tokens to string buffer and print 
    for k in 1..length(Formatted_string) loop
        --if theres two spaces set the characters in between those spaces as a token
        if element(Formatted_string,k) = ' ' then
            Token := Unbounded_Slice(Formatted_string,j,k-1);
            trim(Token, Both);  --trim any spaces off of the token
            --if there are no words currently on the line print the linecount
            if charCount = 0 then
                put(lineCount,8); put("  ");
            end if;
            --if the amount of characters on the line plus the nnumber of chars in the next word are less than or equal to
            --60 add it to the line and increment charcount
            if ((charCount + length(token)) <= 60) and (length(token) > 0) then
                charCount := charCount + length(token);
                Append(Source => Line, New_Item => token);
                --if the charcount is less than 60 add a space and increment the char count
                if charCount < 60 then
                    Ada.Strings.Unbounded.Append(Source => Line, New_Item => " ");
                    charCount := charCount + 1;
                end if;
                j := k;
            --if the charcount plus the length of the enxt word is greater than 60 print out the line and check
            --if its the longest line
            elsif (charCount + length(token)) > 60 then
                trim(line,both);
                Put_line(line); 
                --loop to count words
                for c in 1..length(line) loop
                    if element(line,c) = ' ' then
                        wordCount := wordCount + 1;
                    end if;
                end loop;
                --check for longest and shortest line
                if wordCount >= maxWords then
                    Delete(longLine,1,length(longLine));
                    maxWords := wordCount;
                    Append(longLine,Line);
                    maxLine := lineCount;
                end if;
                if wordCount <= minWords then
                    Delete(shortLine,1,length(shortLine));
                    minWords := wordCount;
                    Append(shortLine,Line);
                    minLine := lineCount;
                end if;
                --reset variables, increment lineCount
                delete(line,1,length(line));
                charCount := 0;
                wordCount := 0;
                lineCount := lineCount + 1;
            end if;
        end if;
    end loop;
    --print out line again at the end of the loop
    Put_line(line);
    --count words again
    for c in 1..length(line) loop
        if element(line,c) = ' ' then
            wordCount := wordCount + 1;
        end if;
    end loop;
    --check one more time for shortest and longest string
    if wordCount >= maxWords then
        Delete(longLine,1,length(longLine));
        maxWords := wordCount;
        Append(longLine,Line);
        maxLine := lineCount;
    end if;
    if wordCount <= minWords then
        Delete(shortLine,1,length(shortLine));
        minWords := wordCount;
        Append(shortLine,Line);
        minLine := lineCount;
    end if;
    --convert shortest and longest line number to string so it is right justified
    append(longLineNumber,Integer'Image(maxLine));
    append(shortLineNumber,Integer'Image(minLine));
    --pad the string so its eight characters long
    while length(longLineNumber) < 8 loop
        append(longLineNumber, " ");
    end loop;
    while length(shortLineNumber) < 8 loop
        append(shortLineNumber, " ");
    end loop;
    --pribt out shortest and longest line
    put("LONG   "); put(longLineNumber); put("     "); put_line(longLine);
    put("SHORT  "); put(shortLineNumber); put("     "); put_line(shortLine);

end screenFormat;