package main

import "fmt"	//import format for I/O

func main(){
	//instantiate variables
	var ic int = 0
	var i int
	numArr := []int{0,0,0,0,0,0,0,0,0,0}
	collArr := []int{0,0,0,0,0,0,0,0,0,0}

	//main loop
	for j := 1; j <= 5000000000; j++ {
		i = j	//save j value in i
		ic = 0
		//loop to calcualte length of collatz sequence
		for ok := true; ok; ok = (i != 1){
			if i % 2 == 0 {	//if even divide by 2
				i /= 2
			} else {	//if odd multiply by 3 and add 1
				i = i * 3 + 1
			}
			ic++		//increment steps
		}
		//check if sequence length is larger than smallest of top 10 sequence lengths
        //Also check if it is already in the array of largets sequence lengths
		if ic > numArr[0] && !(inArray(numArr,ic)) {
			numArr[0] = ic
			collArr[0] = j
			sortArray(numArr,collArr)	//sort parallel arrays
		}
	}
	//print arrays
	fmt.Println("Sorted by sequence length:")
	for n := 0; n < 10; n++ {
		fmt.Print("A starting value of ")
        fmt.Print(collArr[n])
        fmt.Print(" has ")
        fmt.Print(numArr[n])
        fmt.Println(" steps")
	}
	sortArray(collArr,numArr)	//sort other way
	fmt.Println("Sorted by number size:")
	for n := 0; n < 10; n++ {
		fmt.Print("A starting value of ")
        fmt.Print(collArr[n])
        fmt.Print(" has ")
        fmt.Print(numArr[n])
        fmt.Println(" steps")
	}
}

//method to check if an item is in a given array
func inArray(a[] int, num int) bool {
	out := false
	for i := 0; i < 10; i++ {
		if a[i] == num {
			out = true
			break
		}
	}
	return out
}

//method to sort two parallel arrays
func sortArray(a[] int, b[] int) {
	end := len(a)-1
	for {
		if end == 0 {
			break
		}
		for i := 0; i < len(a)-1; i++ {
			if a[i] > a[i+1] {
				//swap both arrays based on first array
				a[i], a[i+1] = a[i+1], a[i]
				b[i], b[i+1] = b[i+1], b[i]
			}
		}
		end--
	}
}