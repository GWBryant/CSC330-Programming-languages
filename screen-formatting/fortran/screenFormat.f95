program screenFormat
    character(:), allocatable :: input_string, char_counter_string, token, longString, shortString, line
    character(len=8) :: sChar, lChar
    !character(len=60) :: line
    character(len = 50) :: cla
    integer :: count, fileSize, lineCount, i, j, numWords, maxWords, minWords, longLine, shortLine

    interface

    subroutine read_file( string, filesize, fileName )
        character(:), allocatable :: string
        character(len=50) :: fileName
        integer :: filesize
    end subroutine read_file

    function format_word(in) result(out)
        character(*), intent(in) :: in
        character(:), allocatable :: out
    end function format_word

    function count_words(in) result(out)
        character(*), intent(in) :: in
        integer :: out
    end function

    end interface
    !get command line argument for file
    call get_command_argument(1, cla)
    !read file from command line arg into inputString
    call read_file(input_string,fileSize,cla)
    !format inputString
    input_string = format_word(input_string)
    !instantiate counter string for reference and print it at top of output
    char_counter_string = "123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*"
    print *, char_counter_string
    !set counts to initial values
    count = 0
    maxWords = 0
    minWords = 60
    numWords = 0
    lineCount  = 1
    j = 1
    line = ""
    !loop to go through tokens and print them to a line & add line numbers
    do i = 1, fileSize
        !get tokens from string with if statement
        if(input_string(i:i) .eq. " ") then
            allocate(character(i-j) :: token) !allocate size for token
            token = input_string(j:i) ! give token value of word
            token = trim(adjustl(token))
            !if there are no characters on a line yet print a line number
            if(count .eq. 0) then
                write(*,fmt="(i9,a2)", advance = "no") lineCount, " "
            endif
            !check if the count plus the length of the word is less than or equal to than 60
            !If it is then print the word and add the length of the character to the count
            if((count + len(trim(adjustl(token))) .le. 60) .and. (len(token) > 0))then
                count = count + len(trim(adjustl(token)))
                line = line//trim(adjustl(token))
                !add a space if and only if the current char count isnt already 60
                if(count .lt. 60) then
                    line = line//" "
                    count = count + 1
                endif
                j = i
            !if the count is greater than 60 then set count to zero and increase the lineCount  
            else if(count + len(trim(adjustl(token))) .gt. 60) then
                !print line and count the number of words
                write(*,fmt = "(a)", advance = "no") trim(adjustl(line))
                numWords = count_words(trim(adjustl(line)))
                !check if current line is the longest line or the shortest, save line and line number
                if(numWords .ge. maxWords) then
                    maxWords = numWords
                    longString = line
                    longLine = lineCount
                endif
                if(numWords .le. minWords) then
                    minWords = numWords
                    shortString = line
                    shortLine = lineCount
                endif
                print *
                !reset variables, increment line count
                count = 0
                line = ""
                numWords = 0
                lineCount = lineCount + 1
            endif
            !deallocate token so it can be reallocated at the top of the loop
            deallocate(token)
        endif
    enddo
    !check last line if its longest/shortest and print it
    !necessary because in all likelihood last line is not 60 characters long
    write(*,fmt = "(a)", advance = "no") trim(adjustl(line))
    numWords = count_words(trim(adjustl(line)))
    if(numWords .ge. maxWords) then
        maxWords = numWords
        longString = line
        longLine = lineCount
    endif
    if(numWords .le. minWords) then
        minWords = numWords
        shortString = line
        shortLine = lineCount
    endif
    !print longest and shortest lines
    write(lChar,'(i8)') longLine
    write(sChar, '(i8)') shortLine
    print *
    print *
    write(*,fmt="(1x,a,a,5x,a)") "LONG   ", adjustl(lChar),trim(adjustl(longString))
    write(*,fmt="(1x,a,a,5x,a)") "SHORT  ", adjustl(sChar),trim(adjustl(shortString))
end program screenFormat

!subroutine to read file into a string
subroutine read_file( string, filesize, fileName )
    character(:), allocatable :: string
    character(len=50) :: fileName
    integer :: counter
    integer :: filesize
    character (LEN=1) :: input
    inquire (file=fileName, size=filesize)
    open(unit=5,status="old",access="direct",form="unformatted",recl=1,&
                    file=fileName)
    allocate( character(filesize) :: string )
    
    counter=1
    100 read (5,rec=counter,err=200) input
        string(counter:counter) = input
        counter=counter+1
        goto 100
    200 continue
    counter=counter-1
    close (5)
end subroutine read_file

!function to format a word
function format_word(in) result(out)
    character(*), intent(in) :: in
    character(:), allocatable :: out, token, word
    integer :: i,j, ascii
    !allocate space for token
    token = in
    !set word equal to token to allocate space for word
    word = token
    !loop to remove non alphanumeric characters from token
    j = 1
    do i = 1, len(token)
            ascii = iachar(token(i:i)) !gets ascii value of char)
            !checks if ascii value is in range of ascii values for all but cardinal numbers
            if((ascii .ge. 32 .and. ascii .le. 47) .or. (ascii .ge. 58 .and. ascii .le. 126) .or. ascii .eq. 10) then
                    word(j:j) = token(i:i)
                    if(ascii .eq. 10) then 
                        word(j:j) = " "
                    endif
                    j = j + 1
            endif
            
    enddo

    !starting from end of line where there are alphanumeric characters replace rest of strimg with spaces for trim function
    do while(j .ne. len(word)+1)
            word(j:j) = " "
            j = j + 1
    enddo

    !trim out spaces before word and return formatted word
    out = adjustl(word)
end function format_word

!function to count all words in a line
function count_words(in) result(out)
    character(*), intent(in) :: in
    integer :: out, i, wordCount
    !all lines have at least one word so we start the count at one
    wordCount = 1
    !loop through line and count spaces, because there must be a word for each space in the line
    !important to start at one since we trim the last space off of the line
    do i = 1, len(in)
        if(in(i:i) .eq. " ") then
            wordCount = wordCount + 1
        endif
    enddo
    !return wordCount
    out = wordCount
end function
