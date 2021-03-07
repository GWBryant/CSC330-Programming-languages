#!/usr/bin/julia

#method to sort two parallel arrays
function sortArray(arr1::AbstractVector,arr2::AbstractVector)
    for _ in 2:length(arr1), j in 1:length(arr1)-1
        if arr1[j] > arr1[j+1]
            arr1[j], arr1[j+1] = arr1[j+1], arr1[j]
            arr2[j], arr2[j+1] = arr2[j+1], arr2[j]
        end
    end
end

#method that checks if a number is in a given array
function inArray(arr::AbstractVector,num::Int64)
    for i in 1:10
        if arr[i] == num
            return true
        end
    end
    return false
end

#recursive function to calculate collatz sequence length
function calcCollatz(n::Int64)
    if n == 1
        return 0
    elseif (n ⊻ 1) == (n+1) #odd/even check using bitwise xor
        return 1 + calcCollatz(n÷2) #if even recursive call w/ num/2
    else
        return 1 + calcCollatz(n*3+1)   #else recursive call w/ num*3+1
    end
end

function main()
    ic = 0
    numArr = [0,0,0,0,0,0,0,0,0,0]
    collArr = [0,0,0,0,0,0,0,0,0,0]
    for j in 1:5000000000
        ic = calcCollatz(j)     #calculate collatz sequence recursively
        #check if sequence length is larger than smallest of top 10 sequence lengths
        #Also check if it is already in the array of largets sequence lengths
        if ic > numArr[1] && !inArray(numArr,ic)
            numArr[1] = ic
            collArr[1] = j
            sortArray(numArr,collArr)   #parallel sort
        end
    end

    #print out arrays
    println("Sorted by sequence length:")
    for n in 1:10
        print("A starting value of ")
        print(collArr[n])
        print(" has ")
        print(numArr[n])
        println(" steps")
    end
    sortArray(collArr,numArr)   #sort other way
    println("Sorted by number size:")
    for n in 1:10
        print("A starting value of ")
        print(collArr[n])
        print(" has ")
        print(numArr[n])
        println(" steps")
    end
end

main()

exit(0)
