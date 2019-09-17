extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal ShutdownButton

signal ShutdownHexagonEngineNow
func _on_JustWorkingAreYouSure_confirmed():
	emit_signal("ShutdownHexagonEngineNow")
	pass # Replace with function body.


func _on_JustWorkingMenu_PressShutDown():
	$JustWorkingAreYouSure.popup()
	pass # Replace with function body.
