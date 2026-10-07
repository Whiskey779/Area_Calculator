package deprecated

import "core:fmt"
import "core:os"
import "core:strconv"

inputBuffer: [50]byte

main :: proc() {
	sides: []string = {"base", "height", "depth"}
	output := GetShapeSidesFromUser(sides[:])
	fmt.println(output)
}

GetShapeSidesFromUser :: proc(sides: []string) -> [dynamic]f32 {
	fmt.print("Please enter the lengths of the sides as they are in order:")
	for side in sides {
		fmt.print("", side)
	}
	fmt.print(":\n")

	num_bytes, err := os.read(os.stdin, inputBuffer[:])
	input := string(inputBuffer[:num_bytes - 1])
	lengthsString := splitString(input)
	lengths: [dynamic]f32
	for length in lengthsString {
		num, _ := strconv.parse_f32(length)
		append(&lengths, num)
	}
	return lengths
}


splitString :: proc(input: string) -> [dynamic]string {
	words: [dynamic]string
	i := 0
	isLastRuneSpace := true
	firstletter := 0
	for r in input {
		i += 1
		if r == ' ' {
			if !isLastRuneSpace {
				append(&words, input[firstletter:i - 1])
			}
			isLastRuneSpace = true
		} else {
			if isLastRuneSpace {
				firstletter = i - 1
			}
			isLastRuneSpace = false
		}
	}
	if !isLastRuneSpace {
		append(&words, input[firstletter:])
	}
	return words
}
