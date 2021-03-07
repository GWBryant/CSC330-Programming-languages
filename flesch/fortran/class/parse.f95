program parse
        
        character(:), allocatable :: line, outline, word

        interface
         subroutine get_next_token(inline,outline,word)
          character (*) :: inline
          character(:), allocatable :: outline, word
         end subroutine get_next_token 
        end interface

        line = "A line of text"
        print *, line
        print *, "The length of the string is ", len(line)

        ! Initialize outline to be same string as line, it will get overwritten
        ! in 
        ! the subroutine, but we need it for loop control
        outline = line

        do while (len(outline) .ne. 0)
          call get_next_token( line, outline, word)
          print *, word
          line = outline
        enddo

end program parse 

subroutine get_next_token( inline, outline, token)
        character (*) :: inline
        character(:), allocatable :: outline, token 
        integer :: i, j
        logical :: foundFirst, foundLast

        ! Initialize variables used to control loop
        foundFirst = .false.
        foundLast  = .false.
        i = 0

        ! find first non blank character
        do while ( .not. foundFirst .and. (i < len(inline)))  
                if (inline(i:i) .eq. " ") then
                        i = i + 1
                else
                        foundFirst = .true.
                endif
        enddo


        j = i
        do while ( foundFirst .and. .not. foundLast .and. ( j < len(inline)))
                if (inline(j:j) .ne. " ") then
                        j = j + 1
                else
                        foundLast = .true.
                endif
        enddo
 
        token = trim(inline(i:j))
        outline = trim(inline(j+1:len(inline)))

end subroutine get_next_token  

