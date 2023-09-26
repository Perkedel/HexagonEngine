extends Node

var activeControlElement : Control

## This is a Collection of Helper Functions
##
## Some of these functions are used elsewhere in the Godot Helpers Plugin
## so it is crucial that this Singleton is activated

func _ready():
	var f = func f(control: Control):
		activeControlElement = control

	get_viewport().connect('gui_focus_changed', f)



## Will return the Root Node of the Scene ( Not the Singletons and not the Windows )
func getSceneRoot() -> Node:
	return get_tree().root.get_child(-1)



func formatSeconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func getAllFilesInDirectory(path, extension = '') -> Array:
	var files = []
	var dir = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()

		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				files.append(file)

		return files

	return []

func objectHasTheseKeys(object: Dictionary, keys: Array) -> bool:
	for requiredKey in keys:
		if not requiredKey in object:
			print('Object is missing required Key "%s" ' % requiredKey, object)
			return false
			break

	return true

func connectEventIfItExists(node: Node, event: String, callable: Callable):
	if node.has_signal(event):
		node.connect(event, callable)

## Will ensure that the file exists at the given path
func ensureFileExists(path: String):
	if not FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.close()

## Will open a json file and return its parsed contents
func getFileAsJson(path: String) -> Dictionary:
	print(path, 'path')
	return JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())

## Will connect a given function to the correct Change Event of the Control Node
func connectChangeEvent(node: Control, callable: Callable):
	var eventName = 'focus_exited'

	if node is ColorPickerButton:
		eventName = 'color_changed'
	elif node is CheckBox:
		eventName = 'pressed'
	elif node is LineEdit:
		eventName = 'text_changed'
	elif node is OptionButton:
		eventName = 'item_selected'
	elif node is SpinBox:
		eventName = 'value_changed'

	node.connect(eventName, callable)

## Returns the value of whatever Control event was given
func getControlValue(node) -> Variant:
	var propertyName = getControlValuePropertyMapping(node.get_class())

	return node[propertyName]

## Set the control value to the given value if they are of the same type
func setControlValue(node: Node, value):
	var propertyName = getControlValuePropertyMapping(node.get_class())

	if typeof(node[propertyName]) == typeof(value):
		node[propertyName] = value

## Returns
func getControlValuePropertyMappings():
	return {
		'CheckBox': 'button_pressed',
		'LineEdit': 'text',
		'ColorPickerButton': 'color',
		'OptionButton': 'selected',
		'SpinBox': 'value'
	}

func getControlValuePropertyMapping(key: String):
	var mappings = getControlValuePropertyMappings()

	if not key in mappings.keys():
		return 'text'
	else:
		return mappings[key]

func getActiveControlElement():
	return activeControlElement
