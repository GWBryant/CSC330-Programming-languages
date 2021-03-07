#!/usr/bin/julia

#main method to run bulk of code
function main()
    #declare and instantiate variables
    minVal::Int64 = 0
    maxVal::Int64 = 0
    max::Int64 = 0
    #get start and end values
    print("Minimun Value: ")
    minVal = parse(Int64,readline())
    print("Maximum Value: ")
    maxVal = parse(Int64,readline())

    #main loop
    for j in minVal:maxVal
        i = j
        #loop to calculate largest number in collatz sequence
        while i != 1
            if i % 2 == 0   #if even divide by 2
                #check for max
                if i > max
                    max = i
                end
                i = i ÷ 2
            else            #if odd multiply by 3 and add 1
                #check for max
                if i > max
                    max = i
                end
                i = i * 3 + 1
            end
        end
    end
    #print max
    println(max)
end

main()

exit(0)