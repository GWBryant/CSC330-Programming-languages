program arraySort

    integer, dimension(5) :: arr

    interface

    subroutine Bubble_Sort(a)
        integer, INTENT(in out), DIMENSION(:) :: a
        integer :: temp
        INTEGER :: i, j
        LOGICAL :: swapped
    end subroutine Bubble_Sort

    end interface

    arr(1) = 3
    arr(2) = 7
    arr(3) = 1
    arr(4) = 5
    arr(5) = 12

    do i = 1,5
        print *, arr(i)
    enddo

    print *, "sort"
    call Bubble_Sort(arr)

    do i = 1,5
        print *, arr(i)
    enddo

end program arraySort

subroutine Bubble_Sort(a)
    integer, intent(in out), dimension(:) :: a
    integer :: temp
    integer :: i, j
    logical :: swapped
   
    do j = size(a)-1, 1, -1
      swapped = .false.
      do i = 1, j
        if (a(i) > a(i+1)) then
          temp = a(i)
          a(i) = a(i+1)
          a(i+1) = temp
          swapped = .true.
        end if
      end do
      if (.NOT. swapped) exit
    end do
end subroutine Bubble_Sort

