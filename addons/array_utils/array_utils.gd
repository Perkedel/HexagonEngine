class_name ArrayUtils
extends Object

## A collection of static utility function for arrays in GDScript
##
## Currently, only a stable sorting implementation is present

## Sorting direction
enum Direction {
	ASC = 1,
	DESC = -1
}

## Sorts the provided input in a [b]stable[/b] manner, which means that elements already in the right
## will not be rearranged. Current implementation might degrade in performance for big arrays 
## (>100 elements).[br]
## [br]
## [param input]: the Array that should be sorted. It should usually contain objects of the same type,
## although you could provide a custom [param comparator] that deals with different object types.[br]
## [param comparator]: a callable that gets two objects of the array passed and should return a [b]negative
## integer[/b] if the first element is smaller than the second, [b]zero[/b] if the elements are equal,
## and a [b]positive integer[/b] if the first element is larger than the second. The class [Comparators]
## provides comparator implementations for a few common data types.[br]
## [param direction]: ascending by default, provide [code]Direction.DESC[/code] to have the array sorted in a decending manner[br]
## [br]
## Example use:
## [codeblock]
## var array := [2, 5, 3, 1, 4]
## ArrayUtils.sort(array, Comparators.NUMBER, ArrayUtils.Direction.DESC)
## print(array)
## => [5, 4, 3, 2, 1]
## [/codeblock]
static func sort(input: Array, comparator: Callable, direction := Direction.ASC) -> void:
	_insertion_sort(input, comparator, direction)


static func _insertion_sort(input: Array, comparator: Callable, direction: int) -> void:
	if input.size() < 2:
		return
	for i in range(1, input.size()):
		var value = input[i]
		var j := i
		while (j > 0 and comparator.call(value, input[j -1]) * direction < 0):
			j -= 1
		input.insert(j, input.pop_at(i))
