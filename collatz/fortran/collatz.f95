program collatz

!declare variables
integer(kind = 8) :: j, i, ic
integer(kind = 8), dimension(10) :: numArr, collArr

!interface section
interface

    subroutine sortArray(a,b)
        integer(kind = 8), INTENT(in out), DIMENSION(:) :: a, b
        integer(kind = 8) :: temp1, temp2
        integer(kind = 8) :: i, j
        LOGICAL :: swapped
    end subroutine sortArray

    logical function inArray(a,num) result(out)
        integer(kind = 8), intent(in), dimension(:) :: a
        integer(kind = 8) :: num
    end function inArray

    end interface

!initialize arrays
do k = 1, 10
        numArr(k) = 0
        collArr(k) = 0
enddo
!loop to calculate all collatz sequences
do j = 1, 5000000000_8
        i = j
        ic=0
        do while ( i /= 1 )  
                if ( mod(i,2) == 0 ) then  ! If even divide by 2
                        i = i / 2
                else
                        i = i * 3 + 1            ! If odd multiply by 3 and add 1
                endif
                ic = ic + 1                ! Increment counter
        enddo
        !check if sequence length is larger than smallest of top 10 sequence lengths
        !Also check if it is already in the array of largets sequence lengths
        if(ic > numArr(1) .and. (.not. inArray(numArr,ic))) then
                numArr(1) = ic
                collArr(1) = j
                call sortArray(numArr,collArr) 
        endif
enddo
!print out arrays
do n = 1, 10
        print *, "A starting value of ",collArr(n), " has ", numArr(n), " steps"
enddo
call sortArray(collArr,numArr) !sort other way
do n = 1, 10
        print *, "A starting value of ",collArr(n), " has ", numArr(n), " steps"
enddo

end program collatz

!sort two arrays in parallel
subroutine sortArray(a,b)
        integer(kind = 8), intent(in out), dimension(:) :: a, b
        integer(kind = 8) :: i, j, temp1, temp2
        logical :: swapped
       
        do j = size(a)-1, 1, -1
          swapped = .false.
          do i = 1, j
            if (a(i) > a(i+1)) then
                !swap both arrays based on 
              temp1 = a(i)
              temp2 = b(i)
              a(i) = a(i+1)
              b(i) = b(i+1)
              a(i+1) = temp1
              b(i+1) = temp2
              swapped = .true.
            end if
          end do
          if (.not. swapped) exit
        end do
end subroutine sortArray

!function to see if an element is in an array
logical function inArray(a,num) result(out)
        integer(kind = 8), intent(in), dimension(:) :: a
        integer(kind = 8) :: num
        out = .false.
        do i = 1, 10
                if(a(i) == num) then
                        out = .true. 
                        exit
                endif
        enddo
end function inArray
