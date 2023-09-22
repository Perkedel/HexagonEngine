class_name Comparators
extends RefCounted

## Collection of comparators for sorting, meant for use in [method ArrayUtils.sort]
##
## The functions with names written in CAPS_CASE are meant to be passed as callables and not called
## as functions, e.g. [code]ArrayUtils.sort(some_input, Comparators.NUMBER)[/code]

## For comparing numbers. If GDScript can substract the values from each other, it should work
static func NUMBER(left, right) -> int:
	return left - right

## Case-sensitive string comparator
static func STR_CASE(left: String, right: String) -> int:
	return left.casecmp_to(right)

## Case-[b]in[/b]sensitive string comparator
static func STR_NO_CASE(left: String, right: String) -> int:
	return left.nocasecmp_to(right)

## Case-sensitive string comparator in [i]natural order[/i]. Results in "1" < "2" < "10"
static func STR_NATURAL_CASE(left: String, right: String) -> int:
	return left.naturalcasecmp_to(right)

## Case-[b]in[/b]sensitive string comparator in [i]natural order[/i]. Results in "1" < "2" < "10"
static func STR_NATURAL_NO_CASE(left: String, right: String) -> int:
	return left.naturalnocasecmp_to(right)

## Helper function that returs a comparator for a specific field of the object to compare. Say you
## have a class like
## [codeblock]
## class Test
## extends Object
## var order: int
## (some other vars/functions...)
## [/codeblock]
## Then you can create a comparator for the [param order] of the class by using
## [code]Comparators.for_field("order", Comparators.NUMBER)[/code]
static func for_field(field_name: String, comparator: Callable) -> Callable:
	return func (left, right):
		return comparator.call(left[field_name], right[field_name])
