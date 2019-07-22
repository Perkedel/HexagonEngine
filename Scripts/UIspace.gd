extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PassMenuScene = "res://GameDVDCardtridge/TemplateHexagonEngine/MenuPart/SettingMenu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func NextMenu(menuToLoad):
	var currMenu = get_node("MainMenu")
	remove_child(currMenu)
	currMenu.call_deferred("free")
	var NextMenu = load(menuToLoad)
	var GoNextMenu = NextMenu.instance()
	add_child(GoNextMenu)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_0):
		#NextMenu(PassMenuScene)
		pass
	pass
