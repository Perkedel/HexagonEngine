extends Resource
class_name ButtonContextTheme
"""
Theme for your button context prompts & bar
"""

export(String) var themeName:String = "Dasandimian choice"
export(String) var themeDescription:String = "Default Dasandimian button theme used in A Hat in Time"
export(String) var pathToJSON:String = "res://modules/SumberDaya/default_button_context_theme.json"
export(Dictionary) var buttonImages:Dictionary

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
	var data:Dictionary = parse_json(handOverFile.get_as_text())
	buttonImages = data.duplicate(true)
	themeName = buttonImages["name"]
	themeDescription = buttonImages["description"]
	pass

func _init():
	
	if pathToJSON and pathToJSON != "":
		# interpret json
		
		
		pass
	pass
