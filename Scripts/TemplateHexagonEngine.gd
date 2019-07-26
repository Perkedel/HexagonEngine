extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Hexagon Engine is like Java but it's Godot. interpreted software! actualy no. it's sub-games inside this
# fantasy console
enum MenuLists {Main_menu = 0, Setting_Menu = 1, Extras_Menu = 2, Unknown_Menu = 3, ChangeDVD_Menu = 3, GameplayUI_Menu = 4}
export(MenuLists) var MenuIsRightNow = 0
export var isPlayingTheGameNow = false
export var PauseTheGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func NextMenu():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

# Place UIspace under CanvasLayer! https://godotengine.org/qa/396/gui-not-following-camera

signal ChangeDVD_Exec()
signal Shutdown_Exec()

func ExecuteChangeDVD():
	emit_signal("ChangeDVD_Exec")
	pass
func ExecuteShutdown():
	emit_signal("Shutdown_Exec")
	pass

func _on_UIspace_ChangeDVD_Exec():
	ExecuteChangeDVD()
	pass # Replace with function body.

func _on_UIspace_Shutdown_Exec():
	ExecuteShutdown()
	pass # Replace with function body.
