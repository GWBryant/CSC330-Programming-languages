#!/usr/bin/julia

#method to sort two parallel arrays
function sortArray(arr1::AbstractVector,arr2::AbstractVector)
    for _ in 2:length(arr1), j in 1:length(arr1)-1
        if arr1[j] > arr1[j+1]
            #swap both arrays based on sort of first array
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

#main method to run bulk of code
function main()
    #declare and instantiate variables
    ic::Int64 = 0
    numArr::Array{Int64,1} = [0,0,0,0,0,0,0,0,0,0]  #array for sequence lengths
    collArr::Array{Int64,1} = [0,0,0,0,0,0,0,0,0,0] #array of top 10 numbers w/ longest collatz sequence

    #main loop
    for j in 1:5000000000
        i = j
        ic = 0
        #loop to calculate collatz sequence length
        while i != 1
            if i % 2 == 0   #if odd divide by 2
                i = i ÷ 2
            else            #if even multiply by 3 and add 1
                i = i * 3 + 1
            end
            ic = ic + 1     # after operation is performed increment how many steps it has taken
        end
        #check if sequence length is larger than smallest of top 10 sequence lengths
        #Also check if it is already in the array of largets sequence lengths
        if ic > numArr[1] && !inArray(numArr,ic)    
            numArr[1] = ic
            collArr[1] = j
            sortArray(numArr,collArr)   #parallel sort of arrays
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