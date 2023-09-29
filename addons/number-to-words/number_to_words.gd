class_name NumberToWords

const ONES = {
	0: "",
	1: "one",
	2: "two",
	3: "three",
	4: "four",
	5: "five",
	6: "six",
	7: "seven",
	8: "eight",
	9: "nine",
	10: "ten",
	11: "eleven",
	12: "twelve",
	13: "thirteen",
	14: "fourteen",
	15: "fifteen",
	16: "sixteen",
	17: "seventeen",
	18: "eighteen",
	19: "nineteen"
}

const TENS = {
	2: "twenty",
	3: "thirty",
	4: "forty",
	5: "fifty",
	6: "sixty",
	7: "seventy",
	8: "eighty",
	9: "ninety"
}

const ILLIONS = {
	1: "thousand", 2: "million", 3: "billion", 4: "trillion", 5: "quadrillion", 6: "quintillion"
}  # godot ints cannot be larger than quintillions

const ORDS = {
	"one": "first",
	"two": "second",
	"three": "third",
	"four": "fourth",
	"five": "fifth",
	"six": "sixth",
	"seven": "seventh",
	"eight": "eighth",
	"nine": "ninth",
	"ten": "tenth",
	"eleven": "eleventh",
	"twelve": "twelfth"
}


# Convert a "number" object to its word equivalent
static func to_words(number) -> String:
	if not number:
		return "zero"

	if number is int:
		if number < 0:
			return _join(["minus", to_cardinal(-number)])
		return to_cardinal(number)

	if number is float:
		if sign(number) == -1:
			return _join(["minus", _convert_float(-number)])
		return _convert_float(number)

	if number is String:
		if number.is_valid_float():
			return to_words(float(number))
		return to_words(int(number))

	return str(number)


static func to_ordinal(number: int) -> String:
	var outwords = to_words(number).split(" ")
	var lastword = outwords[-1]

	if ORDS.has(lastword):
		lastword = ORDS[lastword]
	else:
		if lastword[-1] == "y":
			lastword = lastword.substr(0, lastword.length() - 1) + "ie"
		lastword += "th"
	outwords[-1] = lastword
	return " ".join(outwords)


static func to_ordinal_number(number: int) -> String:
	var suffix = ""
	var number_positive = int(abs(number))
	var last_two_digits = number_positive % 100
	if 4 <= last_two_digits and last_two_digits <= 20:
		suffix = "th"
	else:
		suffix = {1: "st", 2: "nd", 3: "rd"}.get(number_positive % 10, "th")
	return str(number) + suffix


static func to_cardinal(number: int) -> String:
	if number < 20:
		return ONES[number]
	if number < 100:
		return _join([TENS[number / 10], ONES[number % 10]])
	if number < 1000:
		return _divide(number, 100, "hundred")
	var illions_name := ""
	var illions_number := 0
	for key in ILLIONS.keys():
		illions_number = key
		illions_name = ILLIONS[illions_number]
		if number < pow(1000, illions_number + 1):
			break
	return _divide(number, pow(1000, illions_number), illions_name)


static func to_year(number: int) -> String:
	var string_number = str(number)
	var decade = int(string_number.substr(0, string_number.length() - 2))
	var year = int(string_number.right(string_number.length() - 2))

	if (number < 1000 and year == 0) or number < 100:
		return to_words(number)

	if year < 10:
		if not decade % 10:
			return to_words(number)
		if year == 0:
			return _join([to_words(decade), "hundred"])
		return _join([to_words(decade), to_cardinal_numbers("%02d" % year, "oh")])

	return _join([to_words(decade), to_words(year)])


static func to_cardinal_numbers(number, zero_replace := "zero") -> String:
	var to_join := []
	var string_number = str(number)

	if string_number[0] == "-":
		to_join.append("minus")
		string_number = string_number.substr(1)

	for character in string_number:
		if character == ".":
			to_join.append("point")
			continue
		var word = to_cardinal(int(character))
		if word.is_empty():
			word = zero_replace
		to_join.append(word)

	return _join(to_join)


static func _convert_float(number: float) -> String:
	if str(number) == "0":  # godot single-precision can lose accuracy and become 0 :(
		return "zero"
	var segments = str(number).split(".")
	var to_join = [to_cardinal(int(segments[0])), "point"]
	to_join.append(to_cardinal_numbers(segments[1]))
	return _join(to_join)


static func _divide(dividend: int, divisor: int, magnitude: String) -> String:
	if not dividend % divisor:
		return _join([to_cardinal(dividend / divisor), magnitude, to_cardinal(dividend % divisor)])
	if dividend % divisor < 100:
		return _join(
			[to_cardinal(dividend / divisor), magnitude, "and", to_cardinal(dividend % divisor)]
		)
	return _join(
		[to_cardinal(dividend / divisor), magnitude + ",", to_cardinal(dividend % divisor)]
	)


static func _join(args: PackedStringArray) -> String:
	var to_join := PackedStringArray([])
	for arg in args:
		if arg:
			to_join.append(arg)
	return " ".join(to_join)
