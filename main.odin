package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

// raw input bytes are stored here
inputBuffer: [50]u8

// list of the areas found in the programmes run time
historyList: [dynamic]string


//all posible shapes
Shapes :: enum {
	Square,
	Rectangle,
	Circle,
	Trapezium,
}

//program entry point
main :: proc() {
	fmt.println("Welcome to the Area Calculater!")
	if YesOrNo("Do you want to read the instructions?") {
		Instructions()
	}
	for true {
		FindArea()
		if !YesOrNo("Do you want to find another area?") {
			break
		}
	}
	if YesOrNo("Do you want to see your history?") {
		PrintHistory()
	}
}


//prints the history to std out put
PrintHistory :: proc() {
	for value in historyList {
		fmt.println(value)
	}
}

//  picks which shape to calcuate from the users input
FindArea :: proc() {
	shape := GetShapeFromUser()
	switch shape {
	case .Square:
		Square()
	case .Rectangle:
		Rectangle()
	case .Circle:
		Circle()
	case .Trapezium:
		Trapezium()
	}
}


// finds the area of the square by promting the user for the side leangths
Square :: proc() {
	fmt.println("Formula: s^2")
	side := GetShapeLength("Side")
	area := side * side
	fmt.printfln("The Area of the Square is %f", area)
	append(
		&historyList,
		fmt.tprintf("The area of a square with the side lenght of %f is %f.", side, area),
	)
}

// finds the area of the rectangle by promting the user for the side leangths
Rectangle :: proc() {
	fmt.println("Formula: b * h")
	base := GetShapeLength("Base")
	height := GetShapeLength("Height")
	area := base * height
	fmt.printfln("The Area of the Rectangle is %f", area)
	append(
		&historyList,
		fmt.tprintf(
			"The area of a square with the base lenght of %f and the height of %f is %f.",
			base,
			height,
			area,
		),
	)
}

// finds the area of the circle by promting the user for the side leangths
Circle :: proc() {
	fmt.println("Formula: πr^2")
	radius := GetShapeLength("Radius")
	area := math.PI * (radius * radius)
	fmt.printfln("The Area of the Circle is %f", area)
	append(
		&historyList,
		fmt.tprintf("The area of a circle with the radius of %f is %f.", radius, area),
	)
}

// finds the area of the trapezium by promting the user for the side leangths
Trapezium :: proc() {
	fmt.println("Formula: h(a + b)/2")
	height := GetShapeLength("Height")
	a := GetShapeLength("First parallel line")
	b := GetShapeLength("Second parallel line")
	area := height * (a + b) / 2
	fmt.printfln("The Area of the Trapezium is %f", area)
	append(
		&historyList,
		fmt.tprintf(
			"The area of a trapezium with the height of %f, one parral line lenght of %f, and other parral line lenght of %f is %f.",
			height,
			a,
			b,
			area,
		),
	)
}

//takes in the name the a side length and asks the user for its length
GetShapeLength :: proc(lengthName: string) -> f32 {
	for true {
		textLenght := GetUserInput(
			fmt.tprintf(
				"Please enter the length of the %s. (between 0.001 and 1000):",
				lengthName,
			),
		)
		textLenght = RemoveSpaces(textLenght)
		length, ok := strconv.parse_f32(textLenght)
		if ok {
			if length < 0.001 || length > 1000 {
				fmt.println("Please enter a float between 0.001 and 1000")
			} else {
				return length
			}
		} else {
			fmt.printfln(
				"Please enter a floating point number. Can not convert '%s' to float",
				textLenght,
			)
		}
	}
	return 0 // to make compiller happy
}

// gets what shape the user wants to caluate and returns it
GetShapeFromUser :: proc() -> Shapes {
	for true {
		input := GetUserInput(
			"What shapes area do you want to calculate? (square(s) | rectangle(r) | circle(c) | trapezium(t))",
		)
		input = RemoveSpaces(input)
		if input == "trapezium" || input == "t" {
			return Shapes.Trapezium
		}
		if input == "square" || input == "s" {
			return Shapes.Square
		}
		if input == "rectangle" || input == "r" {
			return Shapes.Rectangle
		}
		if input == "circle" || input == "c" {
			return Shapes.Circle
		}
		fmt.println("Please enter \"circle\", \"trapezium\", \"rectangle\" or \"square\"")
	}
	return Shapes.Square // to make compiller happy
}


// prints a prompted to the std out and gets the users responce
GetUserInput :: proc(question: string) -> string {
	fmt.print(strings.concatenate({question, " "}))
	num_bytes, err := os.read(os.stdin, inputBuffer[:])
	if err != 0 {
		fmt.printfln("Error Reading from stdin: %d", err)
		return ""
	}
	return string(inputBuffer[:num_bytes - 1])
}

// gets the user to say yes or no to a question
YesOrNo :: proc(message: string) -> bool {
	for true {
		answer := GetUserInput(strings.concatenate({message, " (yes(y) | no(n))"}))
		answer = RemoveSpaces(answer)
		if answer == "yes" || answer == "y" {
			return true
		}
		if answer == "no" || answer == "n" {
			return false
		}
		fmt.println("Please enter enter \"yes\" or \"no\"")
	}
	return false // to make compiller happy
}


// removes spaces from start and end of a string
RemoveSpaces :: proc(s: string) -> string {
	start := 0
	end := len(s)

	for start < end && s[start] == ' ' {
		start += 1
	}

	for end > start && s[end - 1] == ' ' {
		end -= 1
	}

	return s[start:end]
}


// prints instructions
Instructions :: proc() {
	fmt.printfln(
		`Area Calculator - Instructions

1. Choose a shape:
   Square: square or s
   Rectangle: rectangle or r
   Circle: circle or c
   Trapezium: trapezium or t

2. Enter the requested measurements.
   Measurements must be between 0.001 and 1000.

3. The program will calculate and display the area.

4. Choose whether to calculate another area.
   Enter yes/y or no/n.

5. At the end, choose whether to display your
   calculation history.

Note: Your history is not saved after the program closes.
Note: You can only enter 50 charactres in the input. The rest will be cut off.

Enjoy using the Area Calculator!`,
	)
}
