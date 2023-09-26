extends Node

## This variable holds the Event connections
## NEVER CHANGE THIS VARIABLE DIRECTLY USE THE API FUNCTIONS
var events = {}

## Adds an event listener to the given Event Name
func addEventListener(eventName: String, callable: Callable):
	if not events.has(eventName):
		events[eventName] = []

	events[eventName].append(callable)

## Removes and event Listener from the given Event Name
func removeEventListener(eventName: String, callable: Callable):
	print_debug('Removing event listener "' + eventName + '"')

	if events.has(eventName):
		var i = 0
		for saved_callable in events[eventName]:
			if callable == saved_callable:
				events[eventName].pop_at(i)
			i += 1

## Emits the given Event Name with the Arguments dictionary.
## Will remove Invalid Callables automatically upon encountering them.
func emitEvent(eventName: String, arguments: Dictionary = {}):
	print_debug('Emitting event "' + eventName + '"')

	if events.has(eventName):
		for callable in events[eventName]:
			print(callable)

			if callable.is_valid():
				callable.call(arguments)
			else:
				removeEventListener(eventName, callable)
