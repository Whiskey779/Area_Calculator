package main

import "core:fmt"
import "core:os"
import "core:strings"

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
	shape := GetShapeForUser()
	FindArea(shape)
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
}

Rectange :: proc() {
	fmt.println("Formula: b * h")
}

Circle :: proc() {
	fmt.println("Formula: πr^2")
}

Trapezium :: proc() {
	fmt.println("Formula: h(a + b)/2")
}

GetShapeForUser :: proc() -> Shapes {
	buffer: [10]u8
	for true {
		input := GetUserInput(
			"What shapes area do you want to calculate? (square | rectange | circle | trapezium)",
			buffer[:],
		)
		input = RemoveSpaces(input)
		if input == "trapezium" {
			return Shapes.Trapezium
		}
		if input == "square" {
			return Shapes.Square
		}
		if input == "rectange" {
			return Shapes.Rectange
		}
		if input == "circle" {
			return Shapes.Circle
		}
		fmt.println("Please enter enter \"circle\", \"trapezium\", \"rectange\" or \"square\"")
	}
	return Shapes.Square // to make compiller happy
}

GetUserInput :: proc(question: string, buffer: []u8) -> string {
	fmt.print(strings.concatenate({question, " "}))
	num_bytes, err := os.read(os.stdin, buffer)
	if err != 0 {
		fmt.printfln("Error Reading from stdin: %d", err)
		return ""
	}
	return string(buffer[:num_bytes - 1])
}

YesOrNo :: proc(message: string) -> bool {
	buffer: [6]u8
	for true {
		anwser := GetUserInput(strings.concatenate({message, " (yes | no)"}), buffer[:])
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
