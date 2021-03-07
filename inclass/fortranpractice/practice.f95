program practice
    character(:), allocatable :: string
    string = "hello"
    string = string//""
    string = string//"world"
    print *, '"', trim(string) , '"'
end program practice