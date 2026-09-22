package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

inputBuffer: [50]u8
historyList: [dynamic]string

// square
// rectange
// circle
// trapezium

Shapes :: enum {
	Square,
	Rectange,
	Circle,
	Trapezium,
}

main :: proc() {
	fmt.println("Welcome to the Area Calculater!")
	if YesOrNo("Do you want to read the instructions?") {
		Instructions()
	}
	for true {
		shape := GetShapeFromUser()
		FindArea(shape)
		if !YesOrNo("Do you want to find another area?") {
			break
		}
	}
	if YesOrNo("Do you want to see your history?") {
		PrintHistory()
	}
}

PrintHistory :: proc() {
	for value in historyList {
		fmt.println(value)
	}
}

FindArea :: proc(shape: Shapes) {
	switch shape {
	case .Square:
		Square()
	case .Rectange:
		Rectange()
	case .Circle:
		Circle()
	case .Trapezium:
		Trapezium()
	}
}

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

Rectange :: proc() {
	fmt.println("Formula: b * h")
	base := GetShapeLength("Base")
	height := GetShapeLength("Height")
	area := base * height
	fmt.printfln("The Area of the Rectange is %f", area)
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
			"The area of a trapezium with the height of %f, one parral line lenght of %f and other parral line lenght of %f, is %f.",
			height,
			a,
			b,
			area,
		),
	)
}

GetShapeLength :: proc(lengthName: string) -> f32 {
	for true {
		textLenght := GetUserInput(
			fmt.tprintf("Please enter the length of the %s. (between 0 and 1000):", lengthName),
		)
		textLenght = RemoveSpaces(textLenght)
		length, ok := strconv.parse_f32(textLenght)
		if ok {
			if length <= 0 || length >= 1000 {
				fmt.println("Please enter a float between 0 and 1000")
			} else {
				return length
			}
		} else {
			fmt.printfln(
				"Please enter a floting point number. Can not convet '%s' to float",
				textLenght,
			)
		}
	}
	return 0 // to make compiller happy
}

GetShapeFromUser :: proc() -> Shapes {
	for true {
		input := GetUserInput(
			"What shapes area do you want to calculate? (square | rectange | circle | trapezium)",
		)
		input = RemoveSpaces(input)
		if input == "trapezium" || input == "t" {
			return Shapes.Trapezium
		}
		if input == "square" || input == "s" {
			return Shapes.Square
		}
		if input == "rectange" || input == "r" {
			return Shapes.Rectange
		}
		if input == "circle" || input == "c" {
			return Shapes.Circle
		}
		fmt.println("Please enter enter \"circle\", \"trapezium\", \"rectange\" or \"square\"")
	}
	return Shapes.Square // to make compiller happy
}

GetUserInput :: proc(question: string) -> string {
	fmt.print(strings.concatenate({question, " "}))
	num_bytes, err := os.read(os.stdin, inputBuffer[:])
	if err != 0 {
		fmt.printfln("Error Reading from stdin: %d", err)
		return ""
	}
	return string(inputBuffer[:num_bytes - 1])
}

YesOrNo :: proc(message: string) -> bool {
	for true {
		anwser := GetUserInput(strings.concatenate({message, " (yes | no)"}))
		anwser = RemoveSpaces(anwser)
		if anwser == "yes" || anwser == "y" {
			return true
		}
		if anwser == "no" || anwser == "n" {
			return false
		}
		fmt.println("Please enter enter \"yes\" or \"no\"")
	}
	return false // to make compiller happy
}

RemoveSpaces :: proc(s: string) -> string {
	result := make([dynamic]u8, 0, len(s))

	for c in s {
		if c != ' ' {
			append(&result, u8(c))
		}
	}

	return string(result[:])
}

Instructions :: proc() {
	fmt.printfln("Very Cool Instructions!")
}
