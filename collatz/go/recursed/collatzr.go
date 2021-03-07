package main

import "fmt"

func main(){
	//instantiate variables
	var ic int = 0
	numArr := []int{1,2,3,4,5,6,7,8,9,10}
	collArr := []int{1,2,3,4,5,6,7,8,9,10}
	//main loop
	for j := 1; j <= 5000000000; j++ {
		ic = 0
		//recursive call to calculate collatz sequence length
		calcCollatz(j,&ic)
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

//checks if a given value is in an array
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

//sort two parallel arrays
func sortArray(a[] int, b[] int) {
	end := len(a)-1
	for {
		if end == 0 {
			break
		}
		for i := 0; i < len(a)-1; i++ {
			if a[i] > a[i+1] {
				a[i], a[i+1] = a[i+1], a[i]
				b[i], b[i+1] = b[i+1], b[i]
			}
		}
		end--
	}
}

//calculate collatz sequence recursively
func calcCollatz(n int, ic* int) {
	if n == 1{
		return
	} else if n % 2 == 0 {
		*ic++
		calcCollatz(n/2, ic)
	} else {
		*ic++
		calcCollatz(n*3+1,ic)
	}
	return
}