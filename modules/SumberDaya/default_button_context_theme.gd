extends Resource
class_name ButtonContextTheme
"""
Theme for your button context prompts & bar
"""

@export var themeName: String:String = "Dasandimian choice"
@export var themeDescription: String:String = "Default Dasandimian button theme used in A Hat in Time"
@export var pathToJSON: String:String = "res://modules/SumberDaya/default_button_context_theme.json"
@export var buttonImages: Dictionary:Dictionary

func _loadJSON():
	var Filer:File
	Filer = File.new()
	if Filer.file_exists(pathToJSON):
		match(Filer.open(pathToJSON,_File.READ)):
			OK:
				_parseData(Filer)
				pass
			_:
				pass
	pass

func _parseData(handOverFile:File):
	var test_json_conv = JSON.new()
	test_json_conv.parse(handOverFile.get_as_text())
	var data:Dictionary = test_json_conv.get_data()
	buttonImages = data.duplicate(true)
	themeName = buttonImages["name"]
	themeDescription = buttonImages["description"]
	pass

func _init():
	
	if pathToJSON and pathToJSON != "":
		# interpret json
		
		
		pass
	pass
