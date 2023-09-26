extends Control

@export() var configFilePath: String
@export_file('*.json') var schemaPath = "res://addons/godot_helpers/Nodes/Settings View/example.json"

## Whether Properties that have their Default Value should be removed
@export var shouldFlush: bool = false

const SCHEMA_TYPES = [
	'select',
	'bool',
	'text',
	'number',
	'color',
]

const REQUIRED_KEYS = [
	'name',
	'type',
	'description',
	'default',
]

var schema = {}
var configFile : ConfigFile

# Called when the node enters the scene tree for the first time.
func _ready():
	renderUI()

func renderUI():
	# Create all these Elements
	configFile = ConfigFile.new()

	# Ensuring that the File Exists
	Helpers.ensureFileExists(configFilePath)

	configFile.load(configFilePath)

	# Load the Schema
	schema = Helpers.getFileAsJson(schemaPath)

	# Flush
	if shouldFlush:
		flush()

	# Clearing all Children
	for child in get_children():
		child.queue_free()

	for section in schema.keys():
		print(section)

		var sectionVBox = VBoxContainer.new()
		var sectionLabel = Label.new()
		sectionVBox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sectionLabel.text = section
		sectionVBox.add_child(sectionLabel)

		for row in schema[section]:

			if not _isRowValid(row):
				continue

			var rowVHox = HBoxContainer.new()
			rowVHox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			var rowLabel = Label.new()

			rowVHox.add_child(rowLabel)

			rowLabel.text = row['name']

			var value = configFile.get_value(section, row['name'], row['default'])
			var inputElement = LineEdit.new()

			if row['type'] == 'bool':
				inputElement = CheckBox.new()
				Helpers.setControlValue(inputElement, value)

			elif row['type'] == 'text':
				inputElement = LineEdit.new()
				Helpers.setControlValue(inputElement, value)

			elif row['type'] == 'color':
				inputElement = ColorPickerButton.new()
				Helpers.setControlValue(inputElement, value)

			elif row['type'] == 'number':
				inputElement = SpinBox.new()
				Helpers.setControlValue(inputElement, value)

			elif row['type'] == 'select':
				inputElement = OptionButton.new()

				# TODO CHECK IF ROW HAS options KEY
				# TODO CHECK IF THE DEFAULT VALUE IS IN THE OPTIONS

				for item in row['options']:
					inputElement.add_item(item)

				var currentId = row['options'].find(configFile.get_value(section, row['name'], row['default']))

				inputElement.selected = currentId

			var inter = func inter(arg1 = null, arg2 = null, arg3 = null):
				registerChanges(inputElement, section, row['name'], row)

			# Connect All these Events to ensure that Changes on the Input element are registered
			Helpers.connectChangeEvent(inputElement, inter)

			inputElement.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			rowLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			rowVHox.add_child(inputElement)
			sectionVBox.add_child(rowVHox)

		add_child(sectionVBox)


func registerChanges(node: Node, section: String, key: String, row):
	print('Changes by %s in %s:%s' % [node, section, key])

	var value = Helpers.getControlValue(node)

	if node is OptionButton:
		value = row['options'][value]

	configFile.set_value(section, key, value)
	configFile.save(configFilePath)

	if shouldFlush:
		flush()

func flush():
	print('Flushing')

	for section in schema:
		print(section)

		for row in schema[section]:

			if not _isRowValid(row):
				continue

			var defaultValue = row['default']
			var actualValue = configFile.get_value(section, row['name'], row['default'])

			if var_to_str(defaultValue) == var_to_str(actualValue):
				if configFile.has_section_key(section, row['name']):
					configFile.erase_section_key(section, row['name'])

	configFile.save(configFilePath)


## Determines wether this Row meets the Requirements
func _isRowValid(row):
	if not Helpers.objectHasTheseKeys(row, REQUIRED_KEYS):
		return false

	return true
