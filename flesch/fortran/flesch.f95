program flesch
!variable declaration
character(:), allocatable  :: long_string, word, daleString, token
integer :: filesize, i, j, sentenceCount, sylCount, wordCount, dalefilesize, diffWords
real(kind=8) :: alpha, beta, daleAlpha, fleschKincaid, daleChall, lesch  
character(len=50) :: cla, daleFile
logical :: isNum

!interfaces for subroutines
interface

function is_numeric(string)
  implicit none
  character(*), intent(inout) :: string
  logical :: is_numeric
  real :: x
  integer :: e
end function is_numeric

function format_word(in) result(out)
        character(*), intent(in) :: in
        character(:), allocatable :: out
end function format_word

subroutine read_file( string, filesize, fileName )
        character(:), allocatable :: string
        character(len=50) :: fileName
        integer :: filesize
end subroutine read_file

subroutine countSentences(string, sentenceCount)
        character(:), allocatable :: string
        integer :: sentenceCount, i
end subroutine countSentences

subroutine countSyls(word, sylCount)
        character(:), allocatable :: word
        integer :: sylCount, i
end subroutine countSyls

logical function inDaleWords(string1, string2) result(out)
        character(:), allocatable :: string1, string2
end function inDaleWords

end interface
!set filename for dale chall list
daleFile = "/pub/pounds/CSC330/dalechall/wordlist1995.txt"
!get filepath for bible translation in command line
call get_command_argument(1, cla)
!populate long strings with bible and dale chall list
call read_file( long_string, filesize,cla)
call read_file(daleString,dalefilesize,daleFile)
!format dale chall list
daleString = format_word(daleString)
!variable instantiation
sentenceCount = 0
wordCount = 0
sylCount = 0
diffWords = 0
i = 1
j = 1
isNum = .false.

!tokenizing loop
do j=1, filesize
        !If a cahracter in the bible long string is a space or endline allocate space for that word
        if(long_string(j:j) .eq. " " .or. iachar(long_string(j:j)) .eq. 10) then
                allocate(character(j-i):: token)

                !set token to be equal to space from last whitespace to current whitespace
                token = long_string(i:j)
                word = format_word(token) !format word
                isNum = is_numeric(token)
                if(.not. isNum) then !if token is not a number incrememtn wordcount and count syllables, etc.
                        wordCount  = wordCount + 1
                        call countSentences(token, sentenceCount)
                        call countSyls(token, sylCount)
                        !check for if word is a difficult word
                        if(.not. inDaleWords(daleString,word))then
                                diffWords = diffWords +1
                        endif
                endif
                !deallocate token and word so they can be reallocated as the top of the loop
                deallocate(token)
                deallocate(word)
                !set begining of next word to end of current word
                i = j
        endif
enddo

!calculate scores
alpha = real(sylCount)/real(wordCount)
beta = real(wordCount)/real(sentenceCount)
daleAlpha = real(diffWords)/real(wordCount)
lesch = ceiling((206.835 - (alpha * 84.6) - (beta * 1.015))*10)/10.0
fleschKincaid = ceiling(((alpha * 11.8) + (beta * 0.39) -15.59)*10)/10.0
if((daleAlpha*100) > 5) then
        daleChall = ceiling((((daleAlpha*100)*0.1579)+(beta*0.0496)+3.6365)*10)/10.0
endif
if((daleAlpha*100) <= 5) then
        daleChall = ceiling((((daleAlpha*100)*0.1579)+(beta*0.0496))*10)/10
endif

!print score
print "(f4.1,a8,f4.1,a20,f4.1)", lesch, "      ", fleschKincaid, "                     ", daleChall 

end program flesch

!function to see if input is a number
function is_numeric(string)
  implicit none
  character(*), intent(inout) :: string
  logical :: is_numeric
  real :: x
  integer :: e
  string = trim(adjustl(string))
  read(string,*,iostat=e) x
  is_numeric = (e == 0)
end function is_numeric

!function to convert all chars in string to uppercase
function format_word(in) result(out)
        character(*), intent(in) :: in
        character(:), allocatable :: out, token, word
        integer :: i,j, ascii
        character(*), parameter :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        character(*), parameter :: low = 'abcdefghijklmnopqrstuvwxyz'
        !take token in and convert all characters to lowercase
        token = in
        do i = 1, LEN_TRIM(token)
                j = index(upp,token(i:i))
                if(j > 0) token(i:i) = low(j:j)
        enddo
      
        !set word equal to token to allocate space for word
        word = token

        !loop to remove non alphanumeric characters from token
        j = 1
        do i = 1, len(token)
                ascii = iachar(token(i:i)) !gets ascii value of char
                if( ascii .ge. 97 .and. ascii .le. 122 ) then !checks if ascii value is in range of ascii values for lowercase letters
                        word(j:j) = token(i:i)
                        j = j +1
                else if(ascii .eq. 10) then !checks if ascii value is equal to newline to add spaces in dalechall list
                        word(j:j) = " "
                        j = j + 1
                endif
        enddo

        !starting from end of line where there are alphanumeric characters replace rest of strimg with spaces for trim function
        do while(j .ne. len(word)+1)
                word(j:j) = " "
                j = j + 1
        enddo

        !trim out trailing spaces and return formatted word
        out = trim(word)
end function format_word

!subroutine to read the file and place its contents into a long string
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

!subroutine to count sentences
subroutine countSentences(string, sentenceCount)
        character(:), allocatable :: string
        integer :: sentenceCount, i
        !loop to go through a word
        do i = 1, len(string)
                !if a char in the word is punctuation add to sentence count
                if(string(i:i) .eq. '.' .or. string(i:i) .eq. '?' .or.&
string(i:i) .eq. '!' .or. string(i:i) .eq. ':' .or. string(i:i) .eq. ';') then
                        sentenceCount = sentenceCount + 1
                endif
        enddo
        sentecenCount = sentenceCount + 1
end subroutine countSentences

!subroutine to count syllables
subroutine countSyls(word, sylCount)
        character(:), allocatable :: word
        integer :: sylCount, i
        !loop to go through word
        do i = 1, len(word)
                !if a char is a vowel add to syllabel count
                if(word(i:i) .eq. 'a' .or. word(i:i) .eq. 'e' .or. word(i:i)&
                .eq. 'i' .or. word(i:i) .eq. 'o' .or. word(i:i) .eq. 'u' .or. word(i:) .eq.&
                'y') then
                        sylCount = sylCount + 1
                        !if we arent at the end of the string and the next char is a vowel decrement to syllabel count
                        if(i .le. len(word))then
                                if(word(i+1:i+1) .eq. 'a' .or. word(i+1:i+1) .eq. 'e' .or. word(i+1:i+1)&
                                .eq. 'i' .or. word(i+1:i+1) .eq. 'o' .or. word(i+1:i+1) .eq. 'u' .or. word(i+1:i+1) .eq.&
                                'y') then
                                        sylCount = sylCount - 1
                                endif
                        endif
                endif
        enddo
        !if word ends in e decrement syllable count
        if(word(len(word):len(word)) .eq. 'e') then
                sylCount = sylCount - 1 
        endif
        !all words have at least one syllable
        if(sylCount <= 0) then
                sylCount = sylCount + 1
        endif
end subroutine countSyls

!function to check if word is in dale chall list
logical function inDaleWords(string1,string2) result(out)
        character(:), allocatable :: string1, string2
        out = .false.
        !if there is an index where string 1 is in string 2 the word is an easy word
        if(index(trim(adjustl(string1)), trim(adjustl(string2))) .ne.0)out = .true.
end function inDaleWords