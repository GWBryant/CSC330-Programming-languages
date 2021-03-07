package main

import "fmt"	//import format for I/O

func main(){
	//instantiate variables
	var i int
	var minVal int
	var maxVal int
	fmt.Print("Minimum Value: ")
	fmt.Scan(&minVal)
	fmt.Print("Maximum Value: ")
	fmt.Scan(&maxVal)
	max := 0

	//main loop
	for j := minVal; j <= maxVal; j++ {
		i = j	//save j value in i
		//loop to calcualte largest number in collatz sequences
		for ok := true; ok; ok = (i != 1){
			if i % 2 == 0 {	//if even divide by 2
				if i > max {
					max = i
				}
				i /= 2
			} else {	//if odd multiply by 3 and add 1
				if i > max {
					max = i
				}
				i = i * 3 + 1
			}
		}
		
	}
	fmt.Println(max)
}
