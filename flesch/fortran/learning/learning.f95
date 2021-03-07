program learning

        integer :: i
        character (len = 20):: h 
        integer, dimension(10) :: nums
        i = 2
        read *, h
        !call fillArray(i,nums)
        print *, h        

end program learning

subroutine fillArray(i,nums)

        integer :: i
        integer, dimension(10) :: nums

        do n = 1,10
                nums(n) = i*2
                i = i+2
                print *, nums(n)
        end do

end subroutine fillArray
