extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
export(MenuLists) var MenuIsRightNow = 0
export var isPlayingTheGameNow = false
export var PauseTheGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
