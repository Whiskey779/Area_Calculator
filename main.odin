package main

import "core:fmt"
import "core:os"
import "core:strings"

// square
// rectange
// circle
// trapezium

main :: proc() {
	fmt.println("Welcome to the Area Calculater!")
	buf: [10]u8
	text := YesOrNo("Do you like Math?")
	fmt.println(text)
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
		anwser = remove_spaces(anwser)
		if anwser == "yes" || anwser == "y" {
			return true
		}
		if anwser == "no" || anwser == "n" {
			return false
		}
		fmt.println("Please enter enter \"yes\" or \"no\"")
	}
	return false
}

remove_spaces :: proc(s: string) -> string {
	result := make([dynamic]u8, 0, len(s))

	for c in s {
		if c != ' ' {
			append(&result, u8(c))
		}
	}

	return string(result[:])
}
